require 'active_support/concern'

module Delicious

  module ApiModel
    extend ActiveSupport::Concern

    included do
      attr_writer :persisted, :delicious_client
    end

    def persisted?
      !!@persisted
    end

    module ClassMethods
      def build_persisted(client, attrs)
        obj = new attrs
        obj.persisted = true
        obj.delicious_client = client
        obj
      end
    end
  end

end
