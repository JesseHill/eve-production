require 'yaml'

RSpec.configure do |config|
  config.mock_with :mocha
  config.order = 'random'
end

require "mocha/api"
