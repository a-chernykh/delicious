require 'active_support/concern'

module Delicious
  module DeleteMethod
    extend ActiveSupport::Concern

    def delete_successful?(response)
      code = response.body['result']['code']
      'done' == code
    end
  end
end
