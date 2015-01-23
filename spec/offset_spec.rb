require 'spec_helper'

describe 'Net::NTP::Check' do
  context 'AutoBandPass' do
    it 'should return the correct values with an even number of values' do
      values = (1..9).to_a
      filter_results = Net::NTP::Check::AutoBandPass.filter(values)
      expect(filter_results).to eq(5.0)
    end
    it 'should return the correct values with an odd number of values' do
      values = (1..10).to_a
      filter_results = Net::NTP::Check::AutoBandPass.filter(values)
      expect(filter_results).to eq(6.0)
    end

    it 'should return the correct values with unevenly spaced input' do
      values = [0.15, 0.2, 0.3, 0.4, 0.49, 0.6, 0.7, 0.8, 0.95]
      filter_results = Net::NTP::Check::AutoBandPass.filter(values)
      expect(filter_results).to eq(0.4475)
    end

    it 'should not return the middle value for unevenly spaced numbers' do
      values = [0.15, 0.2, 0.3, 0.4, 0.49, 0.6, 0.7, 0.8, 0.95]
      filter_results = Net::NTP::Check::AutoBandPass.filter(values)
      expect(filter_results).to_not eq(0.49)
    end
  end
end
