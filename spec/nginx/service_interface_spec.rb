require 'spec_helper'

RSpec.describe Nginx::ServiceInterface do
  let(:service) { Nginx::ServiceInterface }
  let(:command) { double(Command, :success? => true) }

  describe "#reboot" do
    before { expect(SystemCommand).to receive(:sudo).with('service nginx restart').and_return(command) }

    it 'should reboot nginx' do
      expect(service.reboot.success?).to eq true
    end
  end

  describe "#update_config" do
    context 'when the configs are valid' do
      let(:config) { {user: 'www-data'} }
      before { expect(Nginx::ConfigGenerator).to receive(:perform).with(config).and_return([true, '/tmp/tmp.conf']) }
      before { expect(SystemCommand).to receive(:sudo).with('mv -f /tmp/tmp.conf /etc/nginx/nginx.conf').and_return(command) }
      before { expect(service).to receive(:reboot).and_return(command) }

      specify do
        expect(service.update_config(config)).to eq true
      end
    end

    context 'when the configs are not valid' do
      let(:config) { {} }
      before { allow(Nginx::ConfigGenerator).to receive(:perform).with(config).and_return([false, nil]) }

      specify do
        expect(service.update_config(config)).to eq false
      end
    end
  end
end
