require_relative 'v1/user'

class MyApi < Grape::API
  prefix 'api'
  version 'v1', using: :path
  mount API::V1::UserEndPoint
end
