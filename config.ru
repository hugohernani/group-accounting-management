require 'sinatra/base'
require 'bundler'
Bundler.require

# requirement for datamapper models
require 'data_mapper'

Dir.glob('./{models,modules,helpers,controllers}/*.rb').each do |file|
  require file
end

require File.join('./controllers', 'api', 'api')

DataMapper.finalize

ENV['RACK_ENV'] ||= 'development'
# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                           "sqlite:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.db")

map('/') { run Rack::Cascade.new [AppController, MyApi] }
