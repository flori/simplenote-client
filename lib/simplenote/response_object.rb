module Simplenote
  class ResponseObject < JSON::GenericObject
    def initialize(*)
      @client = Simplenote::Client.client
      super
    end

    # If this is a note, show it's first line as a title.
    def title
      c = note.content and c[/.*$/]
    end

    # If this is a note, show all lines but the first as a body.
    def body
      c = note.content and c =~ /.*\n/ and $'
    end

    # If this is a note, reload it from the server and return it.
    def note
      @client.show_note(self)
    end

    alias reload note

    # If this is a note, move it into the trash.
    def trash
      @client.trash_note(self)
    end

    # If this is a note, delete it on the server.
    def delete
      @client.delete_note(self)
    end

    # If this is a note update its info with info. It can contain a :content key
    # for the value of the notes content.
    def update(info = {})
      @client.update_note(self, info)
    end

    # If this is a note (contains a content value), return it. Otherwise call
    # inspect for more details.
    def to_s
      content ? content : inspect
    end
  end
end
