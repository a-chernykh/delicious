require 'active_model'

module Delicious
  class Bundle
    include ActiveModel::Model
    include ActiveModel::Validations
    include ApiModel

    attr_accessor :name, :tags

    validates :name, presence: true
    validates :tags, presence: true

    def delete
      if persisted? && @delicious_client
        @delicious_client.bundles.delete bundle: name
      else
        fail 'Bundle was not saved yet'
      end
    end

    def save
      if @delicious_client
        @delicious_client.bundles.set name, tags
      else
        fail 'Bundle was not saved yet'
      end
    end
  end
end
