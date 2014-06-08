require 'delicious'
require 'webmock/rspec'
require 'shoulda/matchers'

require 'helpers/request_helper'

RSpec.configure do |c|
  c.include RequestHelper
end
