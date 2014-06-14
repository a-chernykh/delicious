require 'active_support/concern'

module Delicious
  module Bookmarks
    module Methods

      module Create
        extend ActiveSupport::Concern

        def create(params)
          post = Delicious::Post.new url:         params[:url],
                                     description: params[:description],
                                     extended:    params[:extended],
                                     tags:        params[:tags],
                                     dt:          params[:dt],
                                     shared:      params[:shared]

          if post.valid?
            response = @client.connection.post '/v1/posts/add', params
            code = response.body['result']['code']
            throw code unless 'done' == code
            post.persisted = true
            post.delicious_client = @client
          end

          post
        end
      end

    end
  end
end
