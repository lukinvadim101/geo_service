require 'rails_helper'

RSpec.describe LocationsController do
  describe 'GET Locations' do
    let!(:location) { create(:location) }

    it 'returns success' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'returns location ip' do
      get :index
      expect(response.parsed_body.first['ip']).to eq(location.ip)
    end
  end

  describe 'POST Locations' do
    context 'with valid params' do
      let(:location_params) { attributes_for(:location) }
      let(:location) { instance_double(Location, id: 101) }

      before do
        allow(Location).to receive(:new).with(hash_including(location_params)).and_return(location)
        allow(location).to receive(:save).and_return(true)
      end

      it 'creates a new location' do
        post :create, params: location_params
        expect(response.parsed_body["location"]).to be_truthy
      end

      it 'returns http created' do
        post :create, params: location_params
        expect(response).to have_http_status(:created)
      end

      it 'starts LocationServiceJob Job' do
        expect { post :create, params: location_params }.to have_enqueued_job(LocationServiceJob).with(location.id)
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

    it 'returns location' do
      get :show, params: { id: location.id }
      expect(response.parsed_body['location']['id']).to eq(location.id)
    end
  end

  describe 'DELETE Locations/:id' do
    let!(:location) { create(:location) }

    it 'deletes location' do
      expect { delete :destroy, params: { id: location.id } }.to change(Location, :count).by(-1)
    end

    it 'returns HTTP status :no_content' do
      delete :destroy, params: { id: location.id }
      expect(response).to have_http_status(:no_content)
    end
  end
end
