require 'active_support/concern'

module Delicious
  module Methods
    module Post
      extend ActiveSupport::Concern

      def post(params)
        post = Delicious::Post.new url:         params[:url],
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
          post.delicious_client = self
        end

        post
      end
    end
  end
end
