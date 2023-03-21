require 'rails_helper'

RSpec.describe "Locations" do
  describe "GET /locations" do
    it "returns http success" do
      get "/locations"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /locations" do
    let(:valid_params) { attributes_for(:location) }

    before do
      post "/locations", params: { location: valid_params }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "saves location" do
      expect(response.body).to include('saved')
    end
  end
end
