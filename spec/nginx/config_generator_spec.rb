require 'spec_helper'

RSpec.describe Nginx::ConfigGenerator do
  let(:service)  { Nginx::ConfigGenerator }
  let(:command)  { double(Command, :success? => true) }
  let(:tmp_file) { double(Tempfile, path: '/tmp/tmp.conf') }

  before { allow_any_instance_of(service).to receive(:generate_temporary_config).and_return(tmp_file)}

  describe '#perform' do
    context 'when invalid params' do
      let(:config) { {not_valid_key: 'aaa'} }

      it 'should return false' do
        expect(service.perform(config)).to eq [false, nil]
      end
    end

    context 'when invalid config' do
      let(:config) { {user: 'www-data', worker_processes: '{{{{{'} }
      let(:command) { double(Command, :success? => false) }


      before { expect(SystemCommand).to receive(:sudo).with('nginx -t -c /tmp/tmp.conf').and_return(command) }

      it 'should return false' do
        expect(service.perform(config)).to eq [false, nil]
      end
    end

    context 'success' do
      let(:config) { {user: 'www-data', worker_processes: '4'} }

      before { expect(SystemCommand).to receive(:sudo).with('nginx -t -c /tmp/tmp.conf').and_return(command) }

      it 'should return false' do
        expect(service.perform(config)).to eq [true, '/tmp/tmp.conf']
      end
    end
  end

  describe '#valid_config_file?' do
    before { expect(SystemCommand).to receive(:sudo).with('nginx -t -c /tmp/tmp.conf').and_return(command) }

    let!(:result) { service.new.send(:valid_config_file?, tmp_file) }

    specify { expect(result).to eq true }
  end
end
