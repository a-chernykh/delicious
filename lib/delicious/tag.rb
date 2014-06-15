require 'active_model'

module Delicious
  class Tag
    include ActiveModel::Model
    include ApiModel

    attr_accessor :name, :count

    # Deletes this tag
    #
    # @raise [Delicious::Error] if tag was not saved yet
    # @return [Boolean] `true` upon successful deletion, `false` otherwise
    def delete
      if persisted? && @delicious_client
        @delicious_client.tags.delete(name)
      else
        fail Delicious::Error, 'Tag was not saved yet'
      end
    end
  end
end
