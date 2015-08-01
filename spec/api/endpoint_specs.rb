require File.join(File.dirname(__FILE__), '../spec_helper')

shared_examples "endpoint_api_common_tests" do |data_model|
  endpoint = data_model.name

  it "should return an empty array of #{endpoint} if #{endpoint} is empty, a list of #{endpoint}, otherwise." do
    get "/api/v1/#{endpoint.downcase}s/"
    model_instance = data_model.all
    expect(last_response.status).to be_between(200, 202).inclusive
    expect(last_response.body).to satisfy { |value|
      value == [] || value == model_instance.to_json # check equality list response
    }
  end

  it "should return a #{endpoint} when an id is sent" do
    temp_user = data_model.all[0]
    id = temp_user.nil? ? 1 : temp_user.id
    get "/api/v1/#{endpoint.downcase}s/#{id}/"
    model_instance = data_model.get(id)
    expect(last_response.status).to be_between(200, 202).inclusive
    expect(last_response.body).to satisfy { |value|
      value == model_instance.to_json ||
      value.include?("#{endpoint} not found")
    }
  end


  it "should return true if a #{endpoint} was deleted" do
    temp_user = data_model.all[0]
    id = temp_user.nil? ? 1 : temp_user.id
    delete "api/v1/#{endpoint.downcase}s/#{id}/"
    expect(last_response.status).to be_between(200, 204).inclusive
    expect(last_response.body).to satisfy { |value|
       value == "true" || value.include?("#{endpoint} not deleted")
     }
  end

end
