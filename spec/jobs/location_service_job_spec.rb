require 'rails_helper'

RSpec.describe LocationServiceJob do
  context 'with valid params' do
    let!(:location) { create(:location) }
    let(:service_response) do
      {
        payload: {
          name: 'Mountain View, CA, USA',
          latitude: 37.386051,
          longitude: -122.083855
        }
      }
    end
    let(:location_service_chain) { instance_double(LocationServiceChain) }

    describe 'calls location_service_chain' do
      before do
        allow(Location).to receive(:find).and_return(location)
        allow(LocationServiceChain).to receive(:new).and_return(location_service_chain)
        allow(location_service_chain).to receive(:call).with(location.ip).and_return(service_response)

        described_class.perform_now(location.id)
        location.reload
      end

      it 'calls LocationServiceChain with the correct IP' do
        expect(location_service_chain).to have_received(:call).with(location.ip)
      end

      it 'updates location with response data' do
        expect(location.name).to eq(service_response[:payload][:name])
      end
    end
  end
end
