require './config/environment'

require 'rack'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser
run Sinatra::Application
