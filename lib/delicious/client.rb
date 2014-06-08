require 'faraday'
require 'faraday_middleware'
require 'multi_xml'

module Delicious
  class Client
    attr_accessor :access_token

    def initialize(&block)
      yield(self) if block_given?
    end

    def post(params)
      post = Post.new params

      if post.valid?
        response = connection.post '/v1/posts/add', params
        code = response.body['result']['code']
        throw code unless 'done' == code
        post.persisted = true
      end

      post
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
