module Simplenote
  module API
    # Notes

    # Return the index of notes modified by +query_options+.
    def index(query_options = {})
      options = default_options
      options[:query] |= query_options
      wrap_response do
        self.class.get '/api2/index', options
      end
    end

    # Return the note +note+, where +note+ is either already a note or a note
    # key string.
    def show_note(note)
      wrap_response do
        self.class.get "/api2/data/#{key(note)}", default_options
      end
    end

    alias note show_note


    #  Move the note +note+ into the trash, where +note+ is either already a
    #  note or a note key string.
    def trash_note(note)
      wrap_response do
        self.class.post "/api2/data/#{key(note)}",
          { :body => JSON(:deleted => 1) } | default_options
      end
    end

    #  Delete the note +note+, where +note+ is either already a note or a note
    #  key string.
    def delete_note(note)
      trash_note(note)
      self.class.delete "/api2/data/#{key(note)}", default_options
      true
    end

    #  Update the note +note+ with the +info+ hash, where +note+ is either
    #  already a note or a note key string.
    def update_note(note, info = {})
      wrap_response do
        new_info = {}
        new_info |= info
        self.class.post "/api2/data/#{key(note)}",
          { :body => JSON(new_info) } | default_options
      end
    end


    #  Create a new note with the +info+ hash.
    def create_note(info = {})
      wrap_response do
        self.class.post "/api2/data",
          { :body => JSON(info) } | default_options
      end
    end

    # Tags

    # Return the index of tags modified by +query_options+.
    def tags(query_options = {})
      options = default_options
      options[:query] |= query_options
      wrap_response do
        self.class.get '/api2/tags', options
      end
    end

    #  Create a new tag named +tag_name+ with the +info+ hash.
    def create_tag(tag_name, info = {})
      wrap_response do
        self.class.post "/api2/tags",
          { :body => JSON({ :name => tag_name.to_s} | info) } | default_options
      end
    end

    #  Update the tag +tag_name+ with the +info+ hash.
    def update_tag(tag_name, info = {})
      wrap_response do
        self.class.post "/api2/tags/#{tag_name}",
          { :body => JSON(info) } | default_options
      end
    end

    #  Delete the tag +tag_name+ from the server.
    def delete_tag(tag_name)
      self.class.delete "/api2/tags/#{tag_name}", default_options
      true
    end

    #  Fetch the tag +tag_name+ from the server and show it.
    def show_tag(tag_name)
      wrap_response do
        self.class.get "/api2/tags/#{tag_name}", default_options
      end
    end

    alias tag show_tag
  end
end
