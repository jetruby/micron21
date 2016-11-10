APP_ROOT = File.dirname(__FILE__)

require './services/template_renderer_service'
require './services/system_command'

require './app/statistic_usage'
require './app/interface_manager'
require './app/authentication'

# enable sessions which will be our default for storing the token
enable :sessions

#this is to encrypt the session, but not really necessary just for token because we aren't putting any sensitive info in there
set :session_secret, 'super secret'

AVAILABLE_SERVICES = ['nginx']
JWT_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJub25lIn0.eyJzdWNjZXNzIjp0cnVlfQ.'

namespace '/api/v1/services' do
  before { content_type 'application/json' }
  before { protected! }

  post '/:service/reboot' do
    ensure_service_enabled!

    interface_manager.reboot
    StatisticUsage.register_usage(params[:service])

    { success: true, message: "#{params[:service]} rebooted" }.to_json
  end

  post '/:service/config' do
    ensure_service_enabled!

    StatisticUsage.register_usage(params[:service])

    if interface_manager.update_config(params[:config])
      { success: true, message: "config for #{params[:service]} updated"}.to_json
    else
      { success: false, message: "invalid config for #{params[:service]}"}.to_json
    end
  end

  get '/:service/last_request' do
    ensure_service_enabled!
    timestamp = StatisticUsage.get_last_usage(params[:service])

    if timestamp.present?
      { success: true, message: "#{params[:service]} was updated at #{timestamp}" }.to_json
    else
      { success: false, message: "Has no data for #{params[:service]}" }.to_json
    end
  end

  helpers do
    def ensure_service_enabled!
      halt 404 unless AVAILABLE_SERVICES.include?(params[:service])
    end

    def interface_manager
      InterfaceManager.resolve(params[:service])
    end
  end
end
