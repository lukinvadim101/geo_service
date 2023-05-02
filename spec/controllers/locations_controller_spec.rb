require 'rails_helper'

RSpec.describe LocationsController do
  describe 'GET Locations' do
    let!(:location) { create(:location) }

    it 'returns success' do
      get(:index, format: :json)
      expect(response).to have_http_status(:ok)
    end

    it 'returns location ip' do
      get(:index, format: :json)
      first_location = JSON.parse(response.body).first
      expect(first_location['ip']).to eq(location.ip)
    end
  end

  describe 'POST Locations' do
    let(:location_params) { attributes_for(:location) }
    let(:location_hash) do
      { payload: { ip: location_params[:ip],
                   name: 'Mountain View, 94043',
                   latitude: 37.4192,
                   longitude: -122.0574 } }
    end

    context 'with valid params' do
      before do
        allow(IpstackService).to receive(:new).and_return(geolocation_service)
        allow(geolocation_service).to receive(:call).and_return(location_hash)
      end

      let(:geolocation_service) { instance_double(IpstackService) }

      it 'creates a new location' do
        expect do
          post(:create, params: { ip: location_params[:ip] })
        end.to change(Location, :count).by(1)
      end

      it 'returns http created' do
        post(:create, params: { ip: location_params[:ip] })
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity http status' do
        post(:create, params: nil)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new location' do
        expect { post(:create, params: { location: { ip: nil } }) }.not_to change(Location, :count)
      end

      it 'returns error messages' do
        post(:create, params: { location: { ip: '' } })
        expect(response.parsed_body['error']).to be_truthy
      end
    end
  end

  describe 'GET Locations/:id' do
    let!(:location) { create(:location) }

    it "returns location and status :ok" do
      get :show, params: { id: location.id }
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['location']['id']).to eq(location.id)
    end
  end

  describe 'DELETE Locations/:id' do
    let!(:location) { create(:location) }

    it "deletes location and returns HTTP status :no_content" do
      expect do
        delete :destroy, params: { id: location.id }
      end.to change(Location, :count).by(-1)
      expect(response.status).to eq(204)
    end
  end
end
