require 'active_support/concern'

module Delicious
  module Bundles
    module Methods

      module Delete
        extend ActiveSupport::Concern
        include DeleteMethod

        # Delete bundle with given name
        #
        # @param name [String] Bundle name
        # @return [Boolean] `true` upon a successful deletion, `false` otherwise
        def delete(name)
          response = @client.connection.post '/v1/tags/bundles/delete', bundle: name
          is_delete_successful response
        end
      end

    end
  end
end
