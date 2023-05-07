require 'rails_helper'

RSpec.describe LocationServiceJob do
  context 'with valid params' do
    let(:base_geo_service) { instance_double(BaseGeoService) }
    let!(:location) { create(:location) }
    let(:service_response) { { payload: attributes_for(:location_hash) } }

    describe '#perform with default service parameter' do
      before do
        allow(BaseGeoService).to receive(:new).and_return(base_geo_service)
        allow(base_geo_service).to receive(:call).with(location.ip).and_return(service_response)

        described_class.perform_now(location.id)
        location.reload
      end

      it 'calls BaseGeoService' do
        expect(base_geo_service).to have_received(:call).with(location.ip)
      end

      it 'updates location with response data' do
        expect(location.name).to eq(service_response[:payload][:name])
      end
    end
  end
end
