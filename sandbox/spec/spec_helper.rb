require 'active_record'
require 'yaml'

RSpec.configure do |config|
  config.mock_with :mocha
  config.order = 'random'

  config.before(:suite) {
    dbconfig = YAML::load(File.open('./config/database.yml'))
    ActiveRecord::Base.establish_connection(dbconfig)
  }
end

require "mocha/api"
