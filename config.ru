require 'sinatra/base'
require 'bundler'
Bundler.require

Dir.glob('./{models,modules,helpers,controllers}/*.rb').each do |file|
  require file
end

ENV['RACK_ENV'] ||= 'development'
# A Sqlite3 connection to a persistent database
DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                           "sqlite:///#{Dir.pwd}/db/#{ENV['RACK_ENV']}.db")

map('/') { run AppController }
