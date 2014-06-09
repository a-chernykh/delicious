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
      post = Post.new url:         params[:url],
                      description: params[:description],
                      extended:    params[:extended],
                      tags:        params[:tags],
                      dt:          params[:dt],
                      shared:      params[:shared]

      if post.valid?
        response = connection.post '/v1/posts/add', params
        code = response_code(response)
        throw code unless 'done' == code
        post.persisted = true
      end

      post
    end

    def delete(url)
      response = connection.post '/v1/posts/delete', url: url
      code = response_code(response)
      'done' == code
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
      { 'Authorization' => "Bearer #{access_token}" }.freeze
    end
  end
end
