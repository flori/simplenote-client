module Simplenote
  module API
    # Notes

    def index(query_options = {})
      options = default_options
      options[:query] |= query_options
      wrap_response do
        self.class.get '/api2/index', options
      end
    end

    def tags(query_options = {})
      options = default_options
      options[:query] |= query_options
      wrap_response do
        self.class.get '/api2/tags', options
      end
    end

    def show_note(note)
      wrap_response do
        self.class.get "/api2/data/#{key(note)}", default_options
      end
    end

    alias note show_note

    def trash_note(note)
      wrap_response do
        self.class.post "/api2/data/#{key(note)}",
          { :body => JSON(:deleted => 1) } | default_options
      end
    end

    def delete_note(note)
      trash_note(note)
      self.class.delete "/api2/data/#{key(note)}", default_options
      true
    end

    def update_note(note, info = {})
      wrap_response do
        new_info = {}
        new_info |= info
        self.class.post "/api2/data/#{key(note)}",
          { :body => JSON(new_info) } | default_options
      end
    end

    def create_note(info = {})
      wrap_response do
        self.class.post "/api2/data",
          { :body => JSON(info) } | default_options
      end
    end

    # Tags

    def create_tag(tag_name, info = {})
      wrap_response do
        self.class.post "/api2/tags",
          { :body => JSON({ :name => tag_name.to_s} | info) } | default_options
      end
    end

    def update_tag(tag_name, info = {})
      wrap_response do
        self.class.post "/api2/tags/#{tag_name}",
          { :body => JSON(info) } | default_options
      end
    end

    def delete_tag(tag_name)
      self.class.delete "/api2/tags/#{tag_name}", default_options
      true
    end

    def show_tag(tag_name)
      wrap_response do
        self.class.get "/api2/tags/#{tag_name}", default_options
      end
    end

    alias tag show_tag
  end
end
