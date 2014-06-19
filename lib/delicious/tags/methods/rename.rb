require 'active_support/concern'

module Delicious
  module Tags
    module Methods
      module Rename
        extend ActiveSupport::Concern

        # Renames tag
        #
        # @param old_name [String] Old tag name
        # @param new_name [String] New tag name
        # @return [Boolean] `true` on successful rename
        def rename(old_name, new_name)
          response = @client.connection.post '/v1/tags/rename', 'old' => old_name, 'new' => new_name
          code = response.body['result']['code']
          'done' == code
        end
      end
    end
  end
end
