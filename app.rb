require 'rubygems'
require 'sinatra'
require 'json'
require 'oauth'
require 'oauth/consumer'
  
class App < Sinatra::Application
  
  CONSUMER_KEY = 'financeiro.tardivo.org'
  CONSUMER_SECRET = 'fGtcY96x++/EVnfq3mA/ULQ/'
  
  before do
    session[:oauth] ||= {}  

    consumer_key = CONSUMER_KEY
    consumer_secret = CONSUMER_SECRET

    @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
      :site => "https://www.google.com",
      :request_token_path => '/accounts/OAuthGetRequestToken?scope=http://www.google.com/calendar/feeds',
      :access_token_path => '/accounts/OAuthGetAccessToken',
      :authorize_path => '/accounts/OAuthAuthorizeToken'
    )

    if !session[:oauth][:request_token].nil? && !session[:oauth][:request_token_secret].nil?
      @request_token = OAuth::RequestToken.new(@consumer, session[:oauth][:request_token], session[:oauth][:request_token_secret])
    end

    if !session[:oauth][:access_token].nil? && !session[:oauth][:access_token_secret].nil?
      @access_token = OAuth::AccessToken.new(@consumer, session[:oauth][:access_token], session[:oauth][:access_token_secret])
    end

  end

  get "/" do
    if @access_token
      response = @access_token.get('https://www.google.com/calendar/feeds/default/private/full?alt=jsonc')
      if response.is_a?(Net::HTTPSuccess)
        @data = JSON.parse(response.body)
      else
        STDERR.puts "could not get calendar: #{response.inspect}"
      end
      erb :index
    else
      '<a href="/request">Sign in</a>'
    end
  end
  
  get "/create" do
    json_string = <<EOF
{
  "data": {
    "title": "Tennis with Beth",
    "details": "Meet for a quick lesson.",
    "transparency": "opaque",
    "status": "confirmed",
    "location": "Rolling Lawn Courts",
    "when": [
      {
        "start": "2011-08-02T15:00:00.000Z",
        "end": "2011-08-02T17:00:00.000Z"
      }
    ]
  }
}
EOF

    if @access_token
      response = @access_token.post('https://www.google.com/calendar/feeds/default/private/full', json_string, { 'Accept'=>'application/json', 'Content-Type' => 'application/json' })
      if response.is_a?(Net::HTTPSuccess)
        puts "response.body: #{response.body}"
        redirect "/"
      else
        STDERR.puts "could not create event: #{response.inspect}"
      end
    end
  end
  
  get "/delete" do
    if @access_token
      response = @access_token.delete('https://www.google.com/calendar/feeds/default/private/full/u8ke6vhamhg8djobv821rgb2g8')
      if response.is_a?(Net::HTTPSuccess)
        puts "response.body: #{response.body}"
        redirect "/"
      else
        STDERR.puts "could not delete event: #{response.inspect}"
      end
    end
  end

  get "/request" do
    @request_token = @consumer.get_request_token(:oauth_callback => "#{request.scheme}://#{request.host}:#{request.port}/auth")
    session[:oauth][:request_token] = @request_token.token
    session[:oauth][:request_token_secret] = @request_token.secret
    redirect @request_token.authorize_url
  end

  get "/auth" do
    @access_token = @request_token.get_access_token :oauth_verifier => params[:oauth_verifier]
    session[:oauth][:access_token] = @access_token.token
    session[:oauth][:access_token_secret] = @access_token.secret
    redirect "/"
  end

  get "/logout" do
    session.clear
    @access_token = nil
    @request_token = nil
    @consumer = nil
    redirect "/"
  end
  
end
