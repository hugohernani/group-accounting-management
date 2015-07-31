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
          requires :username, type: String, desc: "Username."
        end
        route_param :username do
          get do
            User.first(params[:username])
          end
        end

        desc 'Create a user'
        params do
          requires :username, type: String, desc: "Username"
          requires :password, type: String, desc: "Password"
          requires :email, type: String, desc: "Email address"
        end
        post do
          user = User.first(:username => params[:username])
          if user.nil?
            user = User.new()
            user.username = params[:username]
            user.password = params[:password]
            user.email = params[:email]
            saved = user.save
          end
          user.attributes
        end

        desc 'Update user password'
        params do
          requires :new_password, type: String, desc: "New password"
        end
        put ":username" do
          user = User.first(:username => params[:username])
          if user
            user.password = params[:new_password]
            user.save
          end
        end

        desc "Delete a user."
        params do
          requires :username, type: String, desc: "username"
        end

        delete ':username' do
          User.first(:username => params[:username]).destroy
        end

      end
    end
  end
end
