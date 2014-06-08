require 'spec_helper'

describe Delicious::Post do
  it { should validate_presence_of :url }
  it { should validate_presence_of :description }
end
