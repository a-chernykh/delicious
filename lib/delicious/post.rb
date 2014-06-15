require 'active_model'

module Delicious
  class Post
    include ActiveModel::Model
    include ActiveModel::Validations
    include ApiModel

    attr_accessor :url, :description, :extended, :tags, :dt, :shared

    validates :url, presence: true
    validates :description, presence: true

    def tags=(t)
      @tags = if t.respond_to?(:to_str)
                t.split(',')
              else
                t || []
              end
    end

    def shared
      @shared ||= false
    end

    # Deletes this bookmark
    #
    # @raise [Delicious::Error] if bookmark was not saved yet
    # @return [Boolean] `true` upon successful deletion, `false` otherwise
    def delete
      if persisted? && @delicious_client
        @delicious_client.bookmarks.delete url: url
      else
        fail 'Bookmark was not saved yet'
      end
    end

    def to_s
      "Delicious::Post(url: #{url}, description: #{description}, tags: #{tags})"
    end
  end
end
