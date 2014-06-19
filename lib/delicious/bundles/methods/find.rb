# encoding: utf-8

require 'active_support/concern'

module Delicious
  module Bundles
    module Methods
      module Find
        extend ActiveSupport::Concern

        # Find a bundle with given name
        #
        # @param name [String] Bundle name
        # @return [Bundle, nil] Found bundle or `nil` if it was not found
        def find(name)
          response = @client.connection.get '/v1/tags/bundles/all', bundle: name
          bundle = response.body['bundles']['bundle']
          Bundle.build_persisted @client, self.class.model_attrs(bundle)
        rescue Faraday::ParsingError
          # it's ridiculous, but delicious returns invalid XML response when bundle is missing
          nil
        end
      end
    end
  end
end
