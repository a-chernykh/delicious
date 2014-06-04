require 'delicious'
require 'webmock/rspec'

require 'helpers/request_helper'

RSpec.configure do |c|
  c.include RequestHelper
end
