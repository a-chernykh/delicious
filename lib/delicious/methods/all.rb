require 'active_support/concern'

module Delicious
  module Methods
    module All
      extend ActiveSupport::Concern

      def all
        response = connection.get '/v1/posts/all'
        response.body['posts']['post'].map do |post_attrs|
          Delicious::Post.new url:         post_attrs['href'],
                              description: post_attrs['description'],
                              extended:    post_attrs['extended'],
                              tags:        post_attrs['tags'],
                              dt:          post_attrs['dt'],
                              shared:      post_attrs['shared']
        end
      end
    end
  end
end
