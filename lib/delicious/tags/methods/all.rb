# encoding: utf-8

require 'active_support/concern'

module Delicious
  module Tags
    module Methods
      module All
        extend ActiveSupport::Concern

        # Get all tags
        #
        # @return [Array<Tag>] List of tags
        def all
          response = @client.connection.get '/v1/tags/get'
          fail Delicious::Error, 'Error getting tags' unless response.body['tags']
          response.body['tags']['tag'].map do |attrs|
            Tag.build_persisted @client, name: attrs['tag'], count: attrs['count'].to_i
          end
        end
      end
    end
  end
end
