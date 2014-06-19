# encoding: utf-8

require 'active_support/concern'

module Delicious
  module ApiModel
    extend ActiveSupport::Concern

    included do
      attr_writer :persisted, :delicious_client
    end

    def persisted?
      !@persisted.nil?
    end

    def to_s
      human_attributes = self.class.attributes.map { |a| %Q(#{a}: "#{public_send(a)}") }.join ', '
      "#{self.class.name}(#{human_attributes})"
    end

    module ClassMethods
      def build_persisted(client, attrs)
        obj = new attrs
        obj.persisted = true
        obj.delicious_client = client
        obj
      end

      def attribute(*names)
        @attributes ||= []
        @attributes += names
        attr_accessor(*names)
      end
      attr_reader :attributes
    end
  end
end
