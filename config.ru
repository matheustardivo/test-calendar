require ::File.expand_path('../app',  __FILE__)
require 'openid/store/filesystem'

use Rack::ShowExceptions
use Rack::Session::Cookie

use OmniAuth::Builder do
    provider :open_id, OpenID::Store::Filesystem.new('./tmp')
    provider :twitter, 'o05IMwcXhJuwmBV4LvUsQA', 'X2s4rKI8GxpRkqhf88WP4XS72qIAp3FYaVJGUCbUUM4'
    use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

run App.new
