require File.join(File.dirname(__FILE__), '../spec_helper')
require File.join(settings.root, '..', 'controllers', 'api', 'v1', 'user')
require File.join('./controllers', 'api', 'api')


describe API::V1::UserEndPoint do
  include Rack::Test::Methods

  def app
    app = MyApi
  end

  describe User do
    context 'Without authentication' do
      it 'should return an empty array of users' do
        get '/api/v1/users/'
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)).to eq [] if User.all.length == 0
      end

      it 'should return a id when a user is created' do
        user_hash = {:username => "hhernanni",
                     :password => "12345678",
                     :email => "hhernanni@gmail.com"}
        post '/api/v1/users/', user_hash
        expect(last_response.status).to be_between(200, 202).inclusive

        hash_body = JSON.parse(last_response.body)
        expect(hash_body["id"]).to be_truthy
      end

      it 'should return a user' do
        get '/api/v1/users/hhernanni'
        user = User.first(:username => "hhernanni")
        expect(last_response.status).to be_between(200, 202).inclusive
        expect(last_response.body).to eq user.to_json
      end

      it 'should return a list of users' do
        get '/api/v1/users/'
        users = User.all
        expect(last_response.status).to be_between(200, 202).inclusive
        expect(last_response.body).to eq users.to_json
      end

      it 'should update a user' do
        params_hash = {:password => "12345678", :new_password => "new_password"}
        put "api/v1/users/hhernanni/", params_hash
        expect(last_response.status).to be_between(200, 204).inclusive
        expect(last_response.body).to satisfy {
          |value| value == "true" || value == "false" }
      end

      it 'should return true if a user was deleted' do
        delete "api/v1/users/hhernanni/"
        expect(last_response.status).to be_between(200, 204).inclusive
        expect(last_response.body).to eq "true"
      end

    end
  end

end
