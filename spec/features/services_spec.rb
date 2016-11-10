require 'spec_helper'

RSpec.describe 'api/v1/services', type: :feature do
  let(:app) { Sinatra::Application }

  before do
    allow_any_instance_of(app).to receive(:protected!).and_return(true)
  end

  describe '#reboot' do
    let(:result) { { success: true, message: "nginx rebooted" } }

    before { expect(Nginx::ServiceInterface).to receive(:reboot) }

    before { post '/api/v1/services/nginx/reboot' }

    specify do
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq result.to_json
    end
  end

  describe 'when updating config of service' do
    let(:result) { { success: true, message: "nginx rebooted" } }
    subject { post '/api/v1/services/nginx/config', config: {user: 'www-data', worker_processes: '4'} }

    context 'when the configs are valid' do
      let(:result) { { success: true, message: 'config for nginx updated' } }

      before { allow_any_instance_of(Nginx::ConfigGenerator).to receive(:valid_config_file?).and_return(true) }

      it { expect(subject.body).to eq result.to_json }
    end

    context 'when the configs are invalid' do
      let(:result) { { success: false, message: 'invalid config for nginx' } }

      before { allow_any_instance_of(Nginx::ConfigGenerator).to receive(:valid_config_file?).and_return(false) }

      it { expect(subject.body).to eq result.to_json }
    end
  end

  describe 'when getting info of last updating of service' do
    before { Redis.new.flushall }

    context 'when timestamp exists' do
      let(:result) { { success: true, message: 'nginx was updated at 1478539875' } }

      before { Redis.new.set('nginx', '1478539875') }
      before { get '/api/v1/services/nginx/last_request' }

      it { expect(last_response.body).to eq result.to_json }
    end

    context 'when timestamp does not exist' do
      let(:result) { { success: false, message: 'Has no data for nginx' } }

      before { get '/api/v1/services/nginx/last_request' }

      it { expect(last_response.body).to eq result.to_json }
    end
  end
end
