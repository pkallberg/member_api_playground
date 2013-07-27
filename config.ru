require './config/environment'
Dir['./app/controllers/**/*.rb'].each {|file| require file}

run Users::API