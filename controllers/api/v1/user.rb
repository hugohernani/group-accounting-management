require 'grape'
path = File.expand_path('../../../../',__FILE__)
require File.join(path, 'models', 'user')

module API
  module V1
    class UserEndPoint < Grape::API
      format :json

      resource :users do
        desc 'List All Users'
        get do
          User.all
        end

        desc 'Return a user.'
        params do
          requires :id, type: Integer, desc: "Id."
        end
        route_param :id do
          get do
            user = User.get(params[:id])
            user.nil? ? {:errors => ["User not found"]} : user
          end
        end

        desc 'Create a user'
        params do
          requires :username, type: String, desc: "Username"
          requires :password, type: String, desc: "Password"
          requires :email, type: String, desc: "Email address"
        end
        post do
          res = {errors:[]}
          user = User.first(:username => params[:username])
          if user.nil?
            user = User.new()
            user.username = params[:username]
            user.password = params[:password]
            user.email = params[:email]
            saved = user.save
          else
            res[:errors].push("User already exists")
          end
          res[:errors].empty? ? user.attributes : res
        end

        desc 'Update user password'
        params do
          requires :new_password, type: String, desc: "New password"
        end
        route_param :id do
          res = {success:[], errors:[]}
          put do
            user = User.first(:id => params[:id])
            unless user.nil?
              user.password = params[:new_password]
              saved = user.save
              saved ? res[:success].push("User updated") : res[:errros].push("User not updated")
            else
              res[:errors].push("User not found")
            end
            res
          end
        end

        desc "Delete a user."
        params do
          requires :id, type: Integer, desc: "id"
        end
        delete ':id' do
          deleted = User.get(params[:id]).destroy
          deleted ? deleted : {:errors => ["User not deleted"]}
        end

      end
    end
  end
end
