module Simplenote
  # The base exception for all Simplenote exception.
  class SimplenoteError < StandardError
    # The http response object that caused the exception
    attr_accessor :http_response
  end

  # This exception is raised if the client fails to login to the server.
  class LoginFailure < SimplenoteError; end

  # This exception is raised if the http response from the server wasn't
  # succesful.
  class QueryFailure < SimplenoteError; end
end
