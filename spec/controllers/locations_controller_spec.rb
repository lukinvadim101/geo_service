require 'rails_helper'

RSpec.describe LocationsController do
  describe 'POST /locations' do
    let(:location_params) { attributes_for(:location) }
    let(:location_hash) do
      { status: response.status,
        payload: { ip: location_params[:ip],
                   name: 'Mountain View, 94043',
                   latitude: 37.4192,
                   longitude: -122.0574 } }
    end

    before do
      allow(IpstackService).to receive(:new).and_return(ipstack_service)
      allow(ipstack_service).to receive(:call).and_return(location_hash)
    end

    context 'with valid params' do
      let(:ipstack_service) { instance_double(IpstackService) }

      it 'creates a new location' do
        expect { post(:create, params: { location: location_params }) }.to change(Location, :count).by(1)
      end

      it 'returns http success' do
        post(:create, params: { location: location_params })
        expect(response).to have_http_status(:success)
      end

      it 'saves location' do
        post(:create, params: { location: location_params })
        expect(response.body).to include('location saved')
      end
    end

    context 'with invalid params' do
      let(:ipstack_service) { instance_double(IpstackService, call: nil) }

      it 'returns http bad request' do
        post(:create, params: nil)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new location' do
        expect { post(:create, params: { location: { ip: '' } }) }.not_to change(Location, :count)
      end

      it 'returns error messages' do
        post(:create, params: { location: { ip: '' } })
        expect(response.body["error"]).not_to be_nil
      end
    end
  end
end
