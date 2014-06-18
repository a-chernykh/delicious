require 'active_support/concern'

module Delicious
  module Bookmarks
    module Methods

      module Delete
        extend ActiveSupport::Concern
        include DeleteMethod

        # Deletes bookmark with given URL
        #
        # @param url [String] Bookmark URL
        # @return [Boolean] `true` on successful deletion, `false` otherwise
        def delete(url)
          response = @client.connection.post '/v1/posts/delete', url: url
          is_delete_successful response
        end
      end

    end
  end
end
