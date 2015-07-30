require 'sinatra'
require 'rack/test'
require 'rspec'

# requirement for datamapper models
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-types'

Dir.glob('./{models,modules,helpers,controllers}/*.rb').each do |file|
  require file
end

# set test environment
configure :test do
  set :run, false
  set :raise_errors, true
  set :logging, false

end

# For testing models
# reset the database before each test to make sure our tests don't influence one another
# Rspec.configure do |config|
#   config.before(:each) { DataMapper.auto_migrate! }
# end
