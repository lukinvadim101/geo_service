require 'rails_helper'

RSpec.describe LocationsController do
  describe 'Get locations' do
    let!(:location) { create(:location) }

    it 'returns success' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns location ip' do
      get(:index, format: :json)
      first_location = JSON.parse(response.body, symbolize_names: true).first
      expect(first_location[:ip]).to eq(location.ip)
    end
  end

  describe 'POST /locations' do
    let(:location_params) { attributes_for(:location) }
    let(:location_hash) do
      { status: response.status,
        payload: { ip: location_params[:ip],
                   name: 'Mountain View, 94043',
                   latitude: 37.4192,
                   longitude: -122.0574 } }
    end

    context 'with valid params' do
      before do
        allow(IpstackService).to receive(:new).and_return(ipstack_service)
        allow(ipstack_service).to receive(:call).and_return(location_hash)
      end

      let(:ipstack_service) { instance_double(IpstackService) }

      it 'creates a new location' do
        expect { post(:create, params: { location: location_params }) }.to change(Location, :count).by(1)
      end

      it 'returns http success' do
        post(:create, params: { location: location_params })
        expect(response).to have_http_status(:success)
      end

      it 'saves location' do
        expect { post(:create, params: { location: { ip: :location_params } }) }.to change(Location, :count)
      end
    end

    context 'with invalid params' do
      # let(:ipstack_service) { instance_double(IpstackService, call: nil) }

      # before do
      #   allow(IpstackService).to receive(:new).and_return(ipstack_service)
      #   allow(ipstack_service).to receive(:call).and_call_original
      # end

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
