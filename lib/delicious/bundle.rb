# encoding: utf-8

require 'active_model'

module Delicious
  class Bundle
    include ActiveModel::Model
    include ActiveModel::Validations
    include ApiModel

    attribute :name, :tags

    validates :name, presence: true
    validates :tags, presence: true

    # Deletes this bundle
    #
    # @raise [Delicious::Error] if bundle was not saved yet
    # @return [Boolean] `true` upon successful deletion, `false` otherwise
    def delete
      if persisted? && @delicious_client
        @delicious_client.bundles.delete bundle: name
      else
        fail Delicious::Error, 'Bundle was not saved yet'
      end
    end

    # Creates or updates bundle
    #
    # @raise [Delicious::Error] if bundle is not associated with Delicious::Client or save failed
    # @return [Boolean] `true` when saved
    def save
      if @delicious_client
        @delicious_client.bundles.set name, tags
        true
      else
        fail 'Bundle was not saved yet'
      end
    end
  end
end
