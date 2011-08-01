require ::File.expand_path('../app',  __FILE__)

use Rack::ShowExceptions
use Rack::Session::Cookie

run App.new
