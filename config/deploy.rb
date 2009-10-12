set :stages, %w(staging prod)
set :default_stage, "prod"
require 'capistrano/ext/multistage'