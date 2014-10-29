module NimbleApi
  class Base

    def initialize(options)
      NimbleApi.client_id = options.fetch(:client_id) { raise ArgumentError.new(":client_id is a required argument to initialize NimbleApi") if NimbleApi.client_id.nil?}
      NimbleApi.client_secret = options.fetch(:client_secret) { raise ArgumentError.new(":client_secret is a required argument to initialize NimbleApi") if NimbleApi.client_secret.nil?}
      NimbleApi.refresh_token = options.fetch(:refresh_token) { raise ArgumentError.new(":refresh_token is a required argument to initialize NimbleApi") if NimbleApi.refresh_token.nil?}

      NimbleApi.host = options.fetch(:host) {"api.nimble.com"}
      NimbleApi.callback_path = options.fetch(:callback_path) { "/auth/nimble/callback"  }
      NimbleApi.api_version = options.fetch(:api_version) { "v1" }

      @conn = Faraday.new(:url => "https://#{NimbleApi.host}" ) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        # faraday.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
      end
      self.refresh
    end

    def base_url
      "https://#{NimbleApi.host}/api/#{NimbleApi.api_version}"
    end

    def refresh
      params = {
        client_id: NimbleApi.client_id,
        client_secret: NimbleApi.client_secret,
        grant_type: 'refresh_token',
        refresh_token: NimbleApi.refresh_token,
        redirect_uri: NimbleApi.callback_path
      }
      resp = @conn.post '/oauth/token', params
      access_token = (JSON resp.body)['access_token']
      @conn.headers = { 'Authorization' => "Bearer #{access_token}" }
      @conn
    end

    def get endpoint, params={}
      resp = @conn.get "#{base_url}/#{endpoint}", params
      return JSON resp.body
    end

    def post endpoint, params
      resp = @conn.post do |req|
        req.url "#{base_url}/#{endpoint}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      return JSON resp.body
    end

    def put endpoint, params
      resp = @conn.put do |req|
        req.url "#{base_url}/#{endpoint}"
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
      return JSON resp.body
    end

    def delete endpoint, params
      resp = @conn.delete "#{base_url}/#{endpoint}", params
      binding.pry
      return JSON resp.body
    end

    def contacts
      NimbleApi::Contacts.new(self)
    end

    def contact
      NimbleApi::Contact.new(self)
    end

    def metadata
      NimbleApi::Metadata.new(self)
    end

  end


  class << self
    attr_accessor :conn,
    :client_id,
    :client_secret,
    :refresh_token,
    :host,
    :callback_path,
    :api_version

    def configure
      yield self
      true
    end
    alias :config :configure
  end
end
