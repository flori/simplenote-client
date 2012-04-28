require 'base64'
require 'json'
if JSON.parser.name == 'JSON::Ext::Parser' &&
  (JSON::VERSION_ARRAY <=> [ 1, 7, 0 ]) < 0
then
  warn "*** WARNING *** use only with JSON 1.7.0 or later"
end
require 'httparty'
require 'uri'
require 'dslkit/polite'
require 'tins/xt/hash_union'
require 'simplenote/api'
require 'simplenote/error'
require 'simplenote/response_object'

module Simplenote
  class Client
    include HTTParty

    class << self
      extend DSLKit::ThreadLocal

      thread_local :client
    end

    base_uri 'https://simple-note.appspot.com'

    def initialize(options = {})
      @email, @password = options.values_at(:email, :password)
    end

    attr_accessor :email

    attr_accessor :password

    def login
      @email and @password or raise LoginFailure, 'email and password required'
      data = Base64.encode64("email=#@email&password=#@password")
      @auth = self.class.post '/api/login', :body => data
      unless @auth.success?
        error = LoginFailure.new(
          "could not login #@email, failed with response code #{@auth.response.code}")
        error.http_response = @auth
        raise error
      end
      @auth
    end

    include API

    def list_notes(query_options = {})
      enum_for(:each_response, :index, query_options).inject([]) do |notes, r|
        notes.concat r.data.select { |n| n.deleted == 0 }.map(&:note)
      end
    end

    def list_notes_for_tag(tag_name, query_options = {})
      tag_name = tag_name.to_s
      enum_for(:each_response, :index, query_options).inject([]) do |notes, r|
        notes.concat r.data.select { |n|
          n.deleted == 0 && n.tags.include?(tag_name)
        }.map(&:note)
      end
    end

    def list_trashed_notes(query_options = {})
      enum_for(:each_response, :index, query_options).inject([]) do |notes, r|
        notes.concat r.data.select { |n| n.deleted == 0 }.map(&:note)
      end
    end

    def list_tags(query_options = {})
      enum_for(:each_response, :tags, query_options).inject([]) do |tags, r|
        tags.concat r.tags
      end
    end

    def list_tags_names(query_options = {})
      list_tags(query_options).map(&:name)
    end

    private

    def wrap_response
      self.class.client = self
      http_response = yield
      unless http_response.success?
        error = QueryFailure.new(
          "query in #{caller.first} failed with response code #{http_response.response}")
        error.http_response = http_response
        raise error
      end
      JSON.parse(http_response.body, :object_class => ResponseObject)
    ensure
      self.class.client = nil
    end

    def each_response(method, query_options = {})
      loop do
        response = __send__(method, query_options)
        if response.count > 0
          yield response
        end
        mark = response.mark or break
        query_options[:mark] = mark
      end
    end

    def auth(reset = false)
      @auth = !reset && @auth || login
    end

    def default_options
      {
        :query  => { :email => @email, :auth => auth },
        :format => :json,
      }
    end

    def key(note)
      key = note.respond_to?(:key) ? note.key : note
      URI.encode(key)
    end
  end
end
