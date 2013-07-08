require './app'
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  UserApi
end