require 'active_model'

module Delicious
  class Post
    include ActiveModel::Model
    include ActiveModel::Validations

    attr_accessor :url, :description, :extended, :tags, :dt, :replace, :shared
    attr_writer :persisted

    validates :url, presence: true
    validates :description, presence: true

    def persisted?
      !!@persisted
    end
  end
end
