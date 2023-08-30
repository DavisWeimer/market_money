require "rails_helper"

RSpec.describe "Market Vendors API" do
  describe "#CREATE" do
    it "creates MarketVendor" do
      vendor_params = attributes_for(:vendor)
      post "/api/v0/vendors", params: { vendor: vendor_params }
      new_vendor = JSON.parse(response.body, symbolize_names: true)
    
      market_params = attributes_for(:market)
      post "/api/v0/markets", params: { market: market_params }
      new_market = JSON.parse(response.body, symbolize_names: true)

      post "/api/v0/market_vendors", params: { vendor: new_vendor[:data][:id], market: new_market[:data][:id] }
      
      expect(response).to have_http_status(:created)

      market_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(market_vendor[:message]).to eq("Successfully added vendor to market")
    end

    it "creates MarketVendor — CREATE fails if id invalid" do
      vendor_params = attributes_for(:vendor)
      post "/api/v0/vendors", params: { vendor: vendor_params }
      new_vendor = JSON.parse(response.body, symbolize_names: true)

      post "/api/v0/market_vendors", params: { vendor: new_vendor[:data][:id], market: "12312312312312" }
      require 'pry'; binding.pry
      expect(response).to have_http_status(:not_found)
      
    end
  end
end