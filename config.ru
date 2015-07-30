require 'sinatra/base'
require 'bundler'
Bundler.require

# requirement for datamapper models
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-validations'

Dir.glob('./{models,modules,helpers,controllers}/*.rb').each do |file|
  require file
end

DataMapper.finalize

ENV['RACK_ENV'] ||= 'development'
# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                           "sqlite:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.db")

map('/') { run AppController }
