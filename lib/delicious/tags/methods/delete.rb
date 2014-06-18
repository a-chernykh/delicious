require 'active_support/concern'

module Delicious
  module Tags
    module Methods

      module Delete
        extend ActiveSupport::Concern
        include DeleteMethod
        
        # Deletes tag
        #
        # @param tag [String] Tag name
        # @return [Boolean] `true` on successful deletion
        def delete(tag)
          response = @client.connection.post '/v1/tags/delete', tag: tag
          is_delete_successful response
        end
      end

    end
  end
end
