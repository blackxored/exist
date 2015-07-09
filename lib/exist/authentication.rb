module Exist
  module Authentication
    def api_key
      @token || ENV['EXIST_API_TOKEN']
    end

    def login!
      resp = client.post(
        'auth/simple-token/',
        username: @options[:username],
        password: @options[:password]
      )

      if resp.body && resp.body['token']
        @token = resp.body['token']
      else
        raise 'There was a problem authenticating with the API'
      end
    end

    def credentials_provided?
      @options[:username] && @options[:password]
    end
  end
end
