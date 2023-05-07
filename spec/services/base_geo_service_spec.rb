require 'rails_helper'

RSpec.describe BaseGeoService do
  describe 'returns child service from GeoService call' do
    let(:ip) { "11.22.22.22" }
    let(:ipstack_service) { instance_double(IpstackService) }
    let(:base_geo_service) { class_double(described_class).as_stubbed_const }
    let(:service_response) { attributes_for(:location_hash) }

    before do
      allow(IpstackService).to receive(:new).and_return(ipstack_service)
      allow(ipstack_service).to receive(:call).with(ip).and_return(service_response)
      allow(base_geo_service).to receive(:new).and_return(ipstack_service)
    end

    context 'default service executed' do
      it 'ipstack gets call' do
        base_geo_service.new.call(ip)
        expect(ipstack_service).to have_received(:call).with(ip)
      end

      it 'return location data' do
        expect(base_geo_service.new.call(ip)).to eq(service_response)
      end
    end
  end
end
