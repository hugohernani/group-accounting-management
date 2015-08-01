# require File.join(File.dirname(__FILE__), '../spec_helper')
require_relative 'endpoint_specs'
require File.join(settings.root, '..', 'controllers', 'api', 'v1', 'post')
require File.join('./controllers', 'api', 'api')


describe API::V1::PostEndPoint do
  include Rack::Test::Methods

  def app
    app = MyApi
  end

  describe Post do
    context "Without authentication" do

      it 'should return a id when a post is created' do
        post_hash = {:title => "New Post",
                     :description => "Just for test"}
        post '/api/v1/posts/', post_hash
        expect(last_response.status).to be_between(200, 202).inclusive

        hash_body = JSON.parse(last_response.body)
        puts "Hash body POST: #{hash_body.to_s}"
        expect(hash_body).to be_truthy
        unless hash_body["errors"].nil?
          expect(hash_body["errors"]).to satisfy do |value|
            value.include?("Post already exists")
          end
        end
      end

      it 'should update a post or answer as not updated and/or not found' do
        params_hash = {:title => "Post Title changed",
          :description => "Post description changed"}
        temp_post = Post.all[0]
        id = temp_post.nil? ? 1 : temp_post.id
        put "api/v1/posts/#{id}/", params_hash
        expect(last_response.status).to be_between(200, 204).inclusive
        expect(last_response.body).to satisfy { |value|
          value.include?("Post updated") ||
          (value.include?("Post not updated") || value.include?("Post not found"))
        }
      end

      include_examples "endpoint_api_common_tests", described_class
    end
  end

end
