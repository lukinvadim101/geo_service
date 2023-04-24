require 'rails_helper'

RSpec.describe IpstackService do
  context 'with valid params' do
    let(:location_params) { attributes_for(:location) }

    it 'returns ip param' do
      response = described_class.new(location_params[:ip]).call
      expect(response[:payload][:ip]).to eq(location_params[:ip])
    end

    it 'returns location name' do
      response = described_class.new(location_params[:ip]).call
      expect(response[:payload][:name]).not_to be_nil
    end
  end

  context 'with invalid params' do
    it 'returns error message' do
      response = described_class.new(nil).call
      expect(response[:error]).not_to be_nil
    end
  end
end
