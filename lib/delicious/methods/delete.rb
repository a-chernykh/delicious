require 'active_support/concern'

module Delicious
  module Methods
    module Delete
      extend ActiveSupport::Concern

      def delete(url)
        response = connection.post '/v1/posts/delete', url: url
        code = response_code(response)
        'done' == code
      end
    end
  end
end
