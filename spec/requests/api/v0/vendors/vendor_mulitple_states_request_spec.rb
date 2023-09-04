require "rails_helper"

RSpec.describe "Vendors API" do
  describe "#GET" do
    it "list of vendors that sell at Markets in more than one state" do
      national_vendor = create(:vendor)
      markets = create_list(:market, 15)
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: national_vendor.id)
      end

      national_vendor_2 = create(:vendor)
      markets = create_list(:market, 4)
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: national_vendor_2.id)
      end

      local_vendor = create(:vendor)
      markets = create_list(:market, 3, state: "Colorado")
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: local_vendor.id)
      end

      get "/api/v0/vendors/multiple_states"

      expect(response).to have_http_status(200)

      vendors = JSON.parse(response.body, symbolize_names: true)

      expect(vendors[:results]).to eq(2)
      
      vendors[:data].each do |vendor|
        expect(vendor[:attributes]).to have_key(:states_sold_in)
        expect(vendor[:attributes][:states_sold_in]).to be_an(Array)
      end
    end
  end
end