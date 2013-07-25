require './config/environment'
#require_relative './app/controllers/base_controller'
Dir['./app/controllers/**/*.rb'].each {|file| require file}

#require "./app"

run Users::API