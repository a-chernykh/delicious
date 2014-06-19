require 'active_support/concern'

module Delicious
  module Bundles
    module Methods
      module Set
        extend ActiveSupport::Concern

        # Update bundle tags
        #
        # @param name [String] Bundle name
        # @param tags [Array<String>] List of new tags for given bundle
        # @raise [Delicious::Error] in case of error
        # @return [Bundle]
        def set(name, tags)
          fail Delicious::Error, "Bundle name can't be blank" if name.nil?
          fail Delicious::Error, 'Please specify at least 1 tag' unless (tags || []).any?
          response = @client.connection.post '/v1/tags/bundles/set', bundle: name, tags: tags.join(',')
          fail Delicious::Error, response.body['result'] unless 'ok' == response.body['result']
          Bundle.build_persisted @client, name: name, tags: tags
        end
      end
    end
  end
end
