require 'bundler'
ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, ENV['RACK_ENV'])

# Dotenv.load '.env', "#{ENV['RACK_ENV']}.env"

Dir['./app/{api,models}/**/*.rb'].each {|file| require file}
Dir['./config/initializers/**/*.rb'].each {|file| require file}
