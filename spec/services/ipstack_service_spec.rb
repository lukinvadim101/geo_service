require 'rails_helper'

RSpec.describe IpstackService do
  context 'with valid params' do
    let(:ip) { attributes_for(:location)[:ip] }

    it 'returns ip param' do
      response = described_class.new.call(ip)
      expect(response[:payload][:ip]).to eq(ip)
    end

    it 'returns location name' do
      response = described_class.new.call(ip)
      expect(response[:payload][:name]).not_to be_nil
    end
  end

  context 'with invalid params' do
    it 'returns error message' do
      response = described_class.new.call(nil)
      expect(response[:error]).not_to be_nil
    end
  end
end
