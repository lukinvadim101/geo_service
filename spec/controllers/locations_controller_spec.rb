require 'rails_helper'

RSpec.describe LocationsController do
  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /locations" do
    context 'with valid params' do
      let(:valid_params) { attributes_for(:location) }

      before do
        post :create, params: { location: valid_params }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "saves location" do
        expect(response.body).to include('saved')
      end
    end

    context 'with invalid params' do
      before do
        post :create, params: { location: { ip: nil } }
      end

      it "returns bad_request http status" do
        expect(response).to have_http_status(:bad_request)
      end

      it "returns error" do
        expect(response.body).to include("can't be blank")
      end
    end
  end
end
