require 'faraday'
require 'faraday_middleware'
require 'multi_xml'

module Delicious
  class Client
    def access_token
      'my-access-token'
    end

    def post(params)
      response = connection.post '/v1/posts/add', params
      code = response.body['result']['code']
      success = code == 'done'
      if success
        Post.new
      else
        throw code
      end
    end

    private

    def connection
      Faraday.new(url: api_endpoint, headers: headers) do |c|
        c.request  :url_encoded
        c.response :xml, content_type: /\bxml$/
        c.adapter  Faraday.default_adapter
      end
    end

    def api_endpoint
      'https://previous.delicious.com'.freeze
    end

    def headers
      { 'Authorization' => "Bearer #{access_token}" }.freeze
    end
  end
end
