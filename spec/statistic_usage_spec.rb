require 'spec_helper'

RSpec.describe StatisticUsage do
  before { Redis.new.flushall }

  let(:time_now) { '1478539875' }
  before { allow(Time).to receive(:now).and_return(1478539875) }
  let(:statistic) { StatisticUsage }

  it 'when we register usage' do
    expect(statistic.register_usage('SuperService')).to eq('OK')
    expect(Redis.new.get('SuperService')).to eq time_now
    expect(statistic.get_last_usage('SuperService')).to eq(time_now)
    expect(statistic.get_last_usage('HardCore')).to eq(nil)
  end
end
