require 'active_support/concern'

module Delicious
  module Bundles
    module Methods

      module Delete
        extend ActiveSupport::Concern

        def delete(name)
          response = @client.connection.post '/v1/tags/bundles/delete', bundle: name
          code = response.body['result']['code']
          'done' == code
        end
      end

    end
  end
end
