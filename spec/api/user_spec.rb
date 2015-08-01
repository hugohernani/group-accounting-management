# require File.join(File.dirname(__FILE__), '../spec_helper')
require_relative 'endpoint_specs'

require File.join(settings.root, '..', 'controllers', 'api', 'v1', 'user')
require File.join('./controllers', 'api', 'api')

describe API::V1::UserEndPoint do
  include Rack::Test::Methods

  def app
    app = MyApi
  end


  describe User do
    context 'Without authentication' do

      it 'should return a id when a user is created' do
        user_hash = {:username => "hhernanni",
                     :password => "12345678",
                     :email => "hhernanni@gmail.com"}
        post '/api/v1/users/', user_hash
        expect(last_response.status).to be_between(200, 202).inclusive

        hash_body = JSON.parse(last_response.body)
        expect(hash_body).to satisfy{ |value|
            not(value["id"].nil?) && value["id"] != "false" ||
            value["errors"].include?("User already exists")
          }
      end

      it 'should update a user or answer as not updated and/or not found' do
        params_hash = {:password => "12345678", :new_password => "new_password"}
        temp_user = User.all[0]
        id = temp_user.nil? ? 1 : temp_user.id
        put "api/v1/users/#{id}/", params_hash
        expect(last_response.status).to be_between(200, 204).inclusive
        expect(last_response.body).to satisfy { |value|
          value.include?("User updated") ||
          (value.include?("User not updated") || value.include?("User not found"))
        }
      end

      include_examples "endpoint_api_common_tests", described_class
    end
  end

end
