require 'sinatra'
require 'omniauth'
  
class App < Sinatra::Application
  
  get '/' do
    erb :login
  end
  
  get '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    raise auth
  end
  
  post '/auth/:name/callback' do
    auth = request.env['omniauth.auth']
    raise auth
  end
  
end
