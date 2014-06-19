require 'active_support/concern'

module Delicious
  module Bundles
    module Methods
      module All
        extend ActiveSupport::Concern

        # Get all user bundles
        #
        # @return [Array<Bundle>] List of bundles
        def all
          response = @client.connection.get '/v1/tags/bundles/all'
          response.body['bundles']['bundle'].map do |attrs|
            Bundle.build_persisted @client, self.class.model_attrs(attrs)
          end
        end
      end
    end
  end
end
