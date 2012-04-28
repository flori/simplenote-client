module Simplenote
  class ResponseObject < JSON::GenericObject
    def initialize(*)
      @client = Simplenote::Client.client
      super
    end

    def title
      c = note.content and c[/.*$/]
    end

    def body
      c = note.content and c =~ /.*\n/ and $'
    end

    def note
      @client.show_note(self)
    end

    alias reload note

    def trash
      @client.trash_note(self)
    end

    def delete
      @client.delete_note(self)
    end

    def update(content)
      @client.update_note(self, content)
    end

    def to_s
      content ? content : inspect
    end
  end
end
