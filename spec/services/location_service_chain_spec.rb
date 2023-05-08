require 'rails_helper'

RSpec.describe LocationServiceChain do
  describe 'calls IpstackService and gets location data' do
    let(:ip_address) { '1.2.3.4' }
    let(:ipstack_service) { instance_double(IpstackService) }
    let(:location_service_chain) { instance_double(described_class) }
    let(:service_response) do
      {
        payload: {
          name: 'Mountain View, CA, USA',
          latitude: 37.386051,
          longitude: -122.083855
        }
      }
    end

    before do
      allow(IpstackService).to receive(:new).and_return(ipstack_service)
      allow(ipstack_service).to receive(:call).with(ip_address).and_return(service_response)

      allow(location_service_chain).to receive(:call).with(ip_address).and_return(service_response)
    end

    it 'calls IpstackService with the correct IP and returns location data' do
      services = [ipstack_service]
      location_service_chain = described_class.new(services)

      result = location_service_chain.call(ip_address)

      expect(result).to eq(service_response)
      expect(ipstack_service).to have_received(:call).with(ip_address)
    end
  end
end
