require_relative 'v1/user'
require_relative 'v1/post'

class MyApi < Grape::API
  prefix 'api'
  version 'v1', using: :path
  mount API::V1::UserEndPoint
  mount API::V1::PostEndPoint
end
