require 'faraday'
require 'faraday_middleware'
require 'multi_xml'

module Delicious
  class Client
    attr_accessor :access_token

    def initialize(&block)
      yield(self) if block_given?
    end

    def bookmarks
      @bookmarks ||= Bookmarks::Api.new(self)
    end

    def bundles
      @bundles ||= Bundles::Api.new(self)
    end

    def connection
      Faraday.new(url: api_endpoint, headers: headers) do |c|
        c.request  :url_encoded
        c.response :xml, content_type: /\bxml$/
        c.adapter  Faraday.default_adapter
      end
    end

    private

    def api_endpoint
      'https://previous.delicious.com'.freeze
    end

    def headers
      { authorization: "Bearer #{access_token}",
        user_agent:    "delicious-ruby #{Delicious.version}" }.freeze
    end
  end
end
