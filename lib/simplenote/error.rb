module Simplenote
  class SimplenoteError < StandardError
    attr_accessor :http_response
  end

  class LoginFailure < SimplenoteError; end

  class QueryFailure < SimplenoteError; end
end
