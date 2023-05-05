require 'rails_helper'

RSpec.describe LocationServiceJob do
  context 'with valid params' do
    let(:ipstack_service) { instance_double(IpstackService) }
    let(:geo_service) { instance_double(GeoService) }
    let!(:location) { create(:location, ip: "11.22.22.22") }
    let(:service_response) { attributes_for(:location_hash) }

    describe '#perform' do
      before do
        allow(GeoService).to receive(:call).with(location.ip).and_return(service_response)
        described_class.perform_now(location.id)
        location.reload
      end

      it 'call GeolocationService' do
        expect(geo_service).to have_received(:call).with(location.ip)
      end

      it 'updates location with response data' do
        expect(location.name).to eq(service_response[:payload][:name])
      end
    end
  end
end
