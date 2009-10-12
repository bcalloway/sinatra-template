require 'rubygems'
require 'vault'

set :env, (ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :production)

run Sinatra::Application