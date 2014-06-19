module Delicious
  module Bookmarks
    class Api
      include Methods::All
      include Methods::Create
      include Methods::Delete

      def initialize(client)
        @client = client
      end
    end
  end
end
