require 'active_support/concern'

module Delicious
  module Bookmarks
    module Methods

      module Delete
        extend ActiveSupport::Concern

        def delete(url)
          response = @client.connection.post '/v1/posts/delete', url: url
          code = response.body['result']['code']
          'done' == code
        end
      end

    end
  end
end
