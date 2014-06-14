require 'active_model'

module Delicious
  class Post
    include ActiveModel::Model
    include ActiveModel::Validations
    include ApiModel

    attr_accessor :url, :description, :extended, :tags, :dt, :shared

    validates :url, presence: true
    validates :description, presence: true

    def delete
      if persisted? && @delicious_client
        @delicious_client.bookmarks.delete url: url
      else
        fail 'Bookmark was not saved yet'
      end
    end
  end
end
