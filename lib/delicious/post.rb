require 'active_model'

module Delicious
  class Post
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :url, :description, :extended, :tags, :dt, :shared
    attr_writer :persisted, :delicious_client

    validates :url, presence: true
    validates :description, presence: true

    def persisted?
      !!@persisted
    end

    def delete
      if persisted? && @delicious_client
        @delicious_client.delete url: url
      else
        fail 'Bookmark was not saved yet'
      end
    end
  end
end
