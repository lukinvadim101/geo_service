# spec/jobs/location_service_job_spec.rb
require 'rails_helper'

RSpec.describe LocationServiceJob do
  context 'with valid params' do
    before do
      allow(IpstackService).to receive(:new).and_return(geolocation_service)
      allow(geolocation_service).to receive(:call).and_return(location_hash)
    end

    let(:geolocation_service) { instance_double(IpstackService) }
    let(:ip_address) { '8.8.8.8' }
    let!(:location) { Location.create(ip: ip_address) }
    let(:location_hash) do
      { payload: { ip: ip_address,
                   name: 'Mountain View, 94043',
                   latitude: 37.4192,
                   longitude: -122.0574 } }
    end

    describe '#perform' do
      before do
        described_class.perform_now(location.id)
      end

      it 'looks up the location geolocation data using the GeolocationService' do
        expect(IpstackService).to have_received(:new).with(location.ip)
        expect(geolocation_service).to have_received(:call)
      end

      it 'updates the location with the geolocation data' do
        expect(Location.last.ip).to eq(ip_address)
        expect(Location.last.name).to eq(location_hash[:payload][:name])
      end
    end
  end
end
