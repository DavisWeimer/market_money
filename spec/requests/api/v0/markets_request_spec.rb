require "rails_helper"

RSpec.describe "Markets API" do
  describe "#GET" do
    it "all Markets" do
      factory_markets = create_list(:market, 10)
      factory_vendors = create_list(:vendor, 50)

      factory_markets.each do |market|
        num_vendors = rand(0..10)
        associated_vendors = factory_vendors.pop(num_vendors)
        associated_vendors.each do |vendor|
          market.vendors.push(vendor)
        end
      end
      
      get "/api/v0/markets"
      expect(response).to be_successful
      
      markets = JSON.parse(response.body, symbolize_names: true)
      expect(markets[:data].count).to eq(10)
      
      markets[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:street)
        expect(market[:attributes][:street]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:city)
        expect(market[:attributes][:city]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:county)
        expect(market[:attributes][:county]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:state)
        expect(market[:attributes][:state]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:zip)
        expect(market[:attributes][:zip]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:lat)
        expect(market[:attributes][:lat]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:lon]).to be_an(String)

        expect(market[:attributes]).to have_key(:lon)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)
      end
    end
  end
end