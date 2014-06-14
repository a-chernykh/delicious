require 'active_support/concern'

module Delicious
  module Bundles
    module Methods

      module All
        extend ActiveSupport::Concern

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
