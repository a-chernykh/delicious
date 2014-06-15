require 'active_support/concern'

module Delicious
  module Tags
    module Methods

      module Delete
        extend ActiveSupport::Concern

        # Deletes tag
        #
        # @param tag [String] Tag name
        # @return [Boolean] `true` on successful deletion
        def delete(tag)
          response = @client.connection.post '/v1/tags/delete', tag: tag
          code = response.body['result']['code']
          'done' == code
        end
      end

    end
  end
end
