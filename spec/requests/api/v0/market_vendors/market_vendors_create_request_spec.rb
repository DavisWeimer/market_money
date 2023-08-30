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

      vendor = Vendor.find(new_vendor[:data][:id])
      market = Market.find(new_market[:data][:id])

      expect(market_vendor[:message]).to eq("Successfully added vendor to market")
      expect(market.vendors.first).to eq(vendor)
      expect(vendor.markets.first).to eq(market)
    end

    it "creates MarketVendor — CREATE fails if id invalid" do
      vendor_params = attributes_for(:vendor)
      post "/api/v0/vendors", params: { vendor: vendor_params }
      new_vendor = JSON.parse(response.body, symbolize_names: true)

      post "/api/v0/market_vendors", params: { vendor: new_vendor[:data][:id], market: "12312312312312" }

      expect(response).to have_http_status(:not_found)

      error = JSON.parse(response.body, symbolize_names: true)

      vendor = Vendor.find(new_vendor[:data][:id])

      expect(error[:errors][0][:detail]).to eq("Validation Failed: Vendor or Market must exist")
      expect(vendor.markets).to eq([])
    end

    it "creates MarketVendor — CREATE fails if association already exists" do
      vendor_params = attributes_for(:vendor)
      post "/api/v0/vendors", params: { vendor: vendor_params }
      new_vendor = JSON.parse(response.body, symbolize_names: true)
    
      market_params = attributes_for(:market)
      post "/api/v0/markets", params: { market: market_params }
      new_market = JSON.parse(response.body, symbolize_names: true)
      
      market_vendor = create(:market_vendor, vendor_id: new_vendor[:data][:id], market_id: new_market[:data][:id])

      post "/api/v0/market_vendors", params: { vendor: new_vendor[:data][:id], market: new_market[:data][:id] }

      expect(response).to have_http_status(:unprocessable_entity)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Validation Failed: Market vendor association between market with market_id=#{new_market[:data][:id]} and vendor_id=#{new_vendor[:data][:id]} already exists")
    end
  end
end