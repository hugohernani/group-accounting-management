require File.join(File.dirname(__FILE__), '/spec_helper')

set :environment, :test

describe "App Test" do
  include Rack::Test::Methods

  def app
    app = AppController
  end

  # Do a root test
  it "should (be_ok|receive 200) on /" do
    get '/'
    expect(last_response).to be_ok
  end
end
