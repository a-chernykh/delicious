require 'active_support/concern'

module Delicious
  module Bundles
    module Methods

      module Find
        extend ActiveSupport::Concern

        def find(name)
          response = @client.connection.get '/v1/tags/bundles/all', bundle: name
          bundle = response.body['bundles']['bundle']
          Bundle.build_persisted @client, self.class.model_attrs(bundle)
        rescue Faraday::ParsingError => e
          # it's ridiculous, but delicious returns invalid XML response when bundle is missing
          nil
        end
      end

    end
  end
end
