require './app'
require 'rspec'
require 'rack/test'

# ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
    config.before(:each) do
    Mongoid.default_session.tap {|session|
      session.collection_names.each {|c| session[c].find.remove_all }
    }
  end
end

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Users::API
end