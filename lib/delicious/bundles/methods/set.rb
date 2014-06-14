require 'active_support/concern'

module Delicious
  module Bundles
    module Methods

      module Set
        extend ActiveSupport::Concern

        def set(name, tags)
          fail Delicious::Error, "Bundle name can't be blank" unless name.present?
          fail Delicious::Error, 'Please specify at least 1 tag' unless (tags || []).any?
          response = @client.connection.post '/v1/tags/bundles/set', bundle: name, tags: tags.join(',')
          fail Delicious::Error, response.body['result'] unless 'ok' == response.body['result']
          Bundle.build_persisted @client, name: name, tags: tags
        end
      end

    end
  end
end
