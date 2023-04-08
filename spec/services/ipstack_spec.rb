require 'rails_helper'

RSpec.describe Ipstack do
  context 'with valid params' do
    let(:param) { '123.23.123.23' }
    let(:response) { described_class.new(param).call }

    it 'returns param' do
      expect(response['ip']).to eq(param)
    end
  end
end
