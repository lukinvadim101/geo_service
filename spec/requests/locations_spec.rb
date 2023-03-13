require 'rails_helper'

RSpec.describe "Locations" do
  describe "GET /locations" do
    it "returns http success" do
      get "/locations"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /locations" do
    it "returns http success" do
      post "/locations", params: { location: { ip: "127.0.0.1" } }
      expect(response).to have_http_status(:success)
    end
  end
end
