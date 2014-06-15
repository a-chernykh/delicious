module Delicious
  module Tags

    class Api
      include Methods::All
      include Methods::Delete
      include Methods::Rename
      
      def initialize(client)
        @client = client
      end
    end

  end
end
