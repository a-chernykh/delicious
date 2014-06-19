# encoding: utf-8

require 'faraday'
require 'faraday_middleware'
require 'multi_xml'
require 'delicious/version'

module Delicious
  class Client
    attr_accessor :access_token

    # Initializes and configures Delicious client. The only requires configuration option
    # for now is `access_token`. Example:
    #
    # ```ruby
    # client = Delicious::Client.new do |client|
    #   client.access_token = 'my-access-token'
    # end
    # ```
    def initialize
      yield(self) if block_given?
    end

    # @return [Bookmarks::Api]
    def bookmarks
      @bookmarks ||= Bookmarks::Api.new(self)
    end

    # @return [Bundles::Api]
    def bundles
      @bundles ||= Bundles::Api.new(self)
    end

    # @return [Tags::Api]
    def tags
      @tags ||= Tags::Api.new(self)
    end

    # @return [Faraday::Connection]
    def connection
      Faraday.new(url: api_endpoint, headers: headers) do |c|
        c.request :url_encoded
        c.response :xml, content_type: /\bxml$/
        c.adapter Faraday.default_adapter
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
