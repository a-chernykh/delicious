module Delicious
  module Bundles

    class Api
      include Methods::Find
      include Methods::All
      include Methods::Delete
      include Methods::Set

      def self.model_attrs(attrs)
        { name: attrs['name'], tags: attrs['tags'].split(' ') }
      end

      def initialize(client)
        @client = client
      end
    end

  end
end
