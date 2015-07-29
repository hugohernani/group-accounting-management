class MainController < Sinatra::Base
  set :views, File.expand_path('../../templates', __FILE__)

  use Rack::Session::Cookie,
    :key => "rack.session",
    :path => "/",
    :secret => "that_is_for_test_TODO"


  helpers Main::Helpers

end
