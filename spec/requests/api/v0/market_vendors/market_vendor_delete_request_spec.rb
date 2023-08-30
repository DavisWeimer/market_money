require "rails_helper"

RSpec.describe "Market Vendors API" do
  before :each do
    vendor_params = attributes_for(:vendor)
    post "/api/v0/vendors", params: { vendor: vendor_params }
    @new_vendor = JSON.parse(response.body, symbolize_names: true)
  
    market_params = attributes_for(:market)
    post "/api/v0/markets", params: { market: market_params }
    @new_market = JSON.parse(response.body, symbolize_names: true)
    
    post "/api/v0/market_vendors", params: { vendor: @new_vendor[:data][:id], market: @new_market[:data][:id] }

    @vendor = Vendor.find(@new_vendor[:data][:id])
    @market = Market.find(@new_market[:data][:id])
  end

  describe "#DELETE" do
    it "deletes MarketVendor" do
      body = { market_id: @market.id, vendor_id: @vendor.id }
      delete "/api/v0/market_vendors", params: body, as: :json

      expect(response).to have_http_status(:no_content)

      expect(@market.vendors).to eq([])
      expect(@vendor.markets).to eq([])
    end

    it "deletes MarketVendor — DELETE fails if id is invalid" do
      body = { market_id: @new_market[:data][:id], vendor_id: "12356dsfu81" }
      delete "/api/v0/market_vendors", params: body, as: :json

      expect(response).to have_http_status(:not_found)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(@market.vendors.count).to eq(1)
      expect(@vendor.markets.count).to eq(1)
      expect(error[:errors][0][:detail]).to eq("No MarketVendor with market_id=#{body[:market_id]} AND vendor_id=#{body[:vendor_id]} exists")
    end
  end
end