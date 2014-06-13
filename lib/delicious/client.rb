require 'faraday'
require 'faraday_middleware'
require 'multi_xml'

module Delicious
  class Client
    attr_accessor :access_token

    include Methods::All
    include Methods::Post
    include Methods::Delete

    def initialize(&block)
      yield(self) if block_given?
    end

    private

    def response_code(response)
      response.body['result']['code']
    end

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
      { authorization: "Bearer #{access_token}",
        user_agent:    "delicious-ruby #{Delicious.version}" }.freeze
    end
  end
end
