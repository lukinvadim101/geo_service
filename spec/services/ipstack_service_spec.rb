require 'rails_helper'

RSpec.describe IpstackService do
  context 'with valid params' do
    let(:param) { '13.22.12.23' }
    let(:response) { described_class.new(param).call }

    it 'returns ip param' do
      expect(response[:location][:ip]).to eq(param)
    end

    it 'returns location name' do
      expect(response[:location][:name]).not_to be_nil
    end
  end
end
