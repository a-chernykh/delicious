require 'active_support/concern'

module Delicious
  module Bundles
    module Methods

      module Delete
        extend ActiveSupport::Concern

        # Delete bundle with given name
        #
        # @param name [String] Bundle name
        # @return [Boolean] `true` upon a successful deletion, `false` otherwise
        def delete(name)
          response = @client.connection.post '/v1/tags/bundles/delete', bundle: name
          code = response.body['result']['code']
          'done' == code
        end
      end

    end
  end
end
