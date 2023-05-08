RSpec.describe LocationServiceChain do
  describe 'returns child service from GeoService call' do
    let(:ip) { attributes_for(:location)[:ip] }
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
      allow(ipstack_service).to receive(:call).with(:ip).and_return(service_response)

      allow(LocationServiceChain).to receive(:new).and_return(location_service_chain)
      allow(location_service_chain).to receive(:call).with(location.ip).and_return(service_response)

      described_class.new([ipstack_service]).call('1.1.2.2')
    end

    context 'when default service executed' do
      it 'ipstack gets call' do
        expect(ipstack_service).to have_received(:call).with('1.1.2.2')
      end
    end
  end
end
