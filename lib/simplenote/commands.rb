require 'tins/xt'
require 'set'
require 'tempfile'
require 'dslkit/polite'
require 'cgi'

module Simplenote
  module Commands
    extend Tins::GO

    module SharedImplementation
      include Tins::GO
      extend DSLKit::Concern

      def client
        Simplenote::Commands.client
      end

      def verbose
        lambda { |t| t.to_hash.map { |k, v| "#{k}: #{v.inspect}" } * ' ' }
      end

      def fancy_note
        lambda { |n|
          [
            n.tags.full? { |tags| "Tags: #{tags * ' '}" },
            "Created: #{Time.at(n.createdate.to_f)}",
            "Modified: #{Time.at(n.modifydate.to_f)}",
            "Key: #{n.key}",
            "Title: #{n.title}",
            '-' * 80,
            "#{n.body}",
            '=' * 80
          ].compact
        }
      end

      def convert_settings_to_info(settings)
        settings = settings.map do |s|
          k, v = s.split('=', 2)
          [ k.to_sym, v ]
        end
        info = {}
        for name, value in settings
          block_given? and new_value = yield(name, value) and value = new_value
          info[name.to_sym] = value
        end
        info
      end

      module ClassMethods
        def help
          name[/::([^:]+)\Z/, 1].underscore
        end
      end
    end

    module Implementations
      def self.[](name)
        const_get name.to_s.camelize
      end

      def self.commands
        constants.map { |c| c.to_s.underscore }
      end

      class Help
        include SharedImplementation

        def call
          puts <<USAGE
Usage: #{File.basename($0)} -e email -p password COMMAND [OPTIONS]

COMMAND must be one of

#{Implementations.commands.map { |c| Implementations[c].help } * "\n\n" }
USAGE
        end

        def self.help
          "#{super}:\n\tdisplays this help." end end 
      class Notes
        include SharedImplementation

        def call(*args)
          opts = go 'vk', args
          if opts['k']
            puts client.list_notes.map(&:key)
          elsif opts['v']
            puts client.list_notes.map(&verbose)
          else
            puts client.list_notes.map(&fancy_note)
          end
        end

        def self.help
<<HELP
#{super} [OPTIONS] KEY displays the notes.

OPTION -k just displays the notes' keys
OPTION -v formats in a verbose (but not fancy) way.
HELP
        end
      end

      class Note
        include SharedImplementation

        def call(*args)
          opts = go 'e:vs:c:d:', args
          if key = opts['e']
            content = client.note(key).content
            Tempfile.open('simplenote') do |f|
              f.write content
              f.close
              system "#{ENV['VISUAL'] || ENV['EDITOR'] || 'vim'} #{f.path}"
              new_content = File.read(f.path)
              client.update_note key, content: new_content
            end
          elsif settings = opts['s']
            key = args.first or raise ArgumentError, 'require one key argument'
            info = convert_settings_to_info settings do |name, value|
              case name
              when :tags, :systemtags
                value.split(',')
              end
            end
            client.update_note key, info
          elsif contents = opts['c']
            for content in contents
              client.create_note content: content
            end
          elsif keys = opts['d']
            for key in keys
              client.delete_note key
            end
          elsif opts['v']
            puts verbose[client.note(key)]
          else
            puts fancy_note[client.note(key)]
          end
        end
      end

      class Tags
        include SharedImplementation

        def call(*args)
          opts = go 'v', args
          if opts['v']
            puts client.list_tags.map(&verbose)
          else
            puts client.list_tags_names
          end
        end
      end

      class Tag
        include SharedImplementation

        def call(*args)
          opts = go 'd:s:c:', args
          if settings = opts['s']
            tag_name = args.first or raise ArgumentError, 'require one tag_name argument'
            tag_name = CGI.escape(tag_name)
            info = convert_settings_to_info settings
            client.update_tag tag_name, info
          elsif tag_names = opts['d']
            for tag_name in tag_names
              tag_name = CGI.escape(tag_name)
              client.delete_tag tag_name
            end
          elsif tag_names = opts['c']
            for tag_name in tag_names
              tag_name = CGI.escape(tag_name)
              client.create_tag tag_name
            end
          else
            puts verbose[client.show_tag(tag_name)]
          end
        end
      end
    end

    class << self
      def help
        Implementations::Help.new.call
      end

      def call(*args)
        auth = go 'e:p:', args
        email, password = auth.values_at('e', 'p')
        @client = email.full? && password.full? &&
          Simplenote::Client.new(:email => email, :password => password)
        if @client and
          klass = args.shift.full?(:camelize) and
          Implementations.constants.include?(klass.to_sym) and
          klass = Implementations[klass]
        then
          klass.new.call(*args)
        else
          self.result_code = 1
          help
        end
        result_code
      end

      attr_reader :client

      attr_accessor :result_code
      Simplenote::Commands.result_code = 0
    end
  end
end
