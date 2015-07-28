class AppController < MainController
  # registered modules

  #helpers

  init_app = lambda do
    erb :index
  end

  get '/', &init_app

  get '/resetdb' do
    DataMapper.auto_migrate!
    "Finished"
  end

end
