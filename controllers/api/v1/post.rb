require 'grape'
path = File.expand_path('../../../../',__FILE__)
require File.join(path, 'models', 'post')

module API
  module V1
    class PostEndPoint < Grape::API
      format :json

      resource :posts do
        desc 'List All posts'
        get do
          Post.all
        end

        desc 'Return a post.'
        params do
          requires :id, type: Integer, desc: "Id."
        end
        route_param :id do
          get do
            post = Post.get(params[:id])
            post.nil? ? {:errors => ["Post not found"]} : post
          end
        end

        desc 'Create a post'
        params do
          requires :title, type: String, desc: "Title"
          requires :description, type: String, desc: "Description"
        end
        post do
          res = {errors:[]}
          post = Post.first(:title => params[:title])
          if post.nil?
            post = Post.new()
            post.title = params[:title]
            post.description = params[:description]
            saved = post.save
          else
            res[:errors].push("Post already exists")
          end
          res[:errors].empty? ? post.attributes : res
        end

        desc 'Update title and description'
        params do
          requires :title, type: String, desc: "Title"
          requires :description, type: String, desc: "Description"
        end
        route_param :id do
          res = {success:[], errors:[]}
          put do
            post = Post.get(params[:id])
            unless post.nil?
              post.title = params[:title]
              post.description = params[:description]
              saved = post.save
              saved ? res[:success].push("Post updated") : res[:errros].push("Post not updated")
            else
              res[:errors].push("Post not found")
            end
            res
          end
        end

        desc "Delete a post."
        params do
          requires :id, type: Integer, desc: "id"
        end
        delete ':id' do

          deleted = Post.get(params[:id]).destroy
          deleted ? deleted : {:errors => ["Post not deleted"]}
        end
      end

    end
  end
end
