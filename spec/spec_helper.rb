require 'coveralls'
Coveralls.wear!

require 'delicious'
require 'webmock/rspec'
# ActiveModel should be required before shoulda/matchers
require 'active_model'
require 'shoulda/matchers'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |c|
  c.include RequestHelper
end
