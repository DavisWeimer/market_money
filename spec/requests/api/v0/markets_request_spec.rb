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

      expect(response).to have_http_status(200)
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

    it "Market by id" do
      id = create(:market).id

      get "/api/v0/markets/#{id}"

      expect(response).to have_http_status(200)
      expect(response).to be_successful

      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data]).to have_key(:id)
      expect(market[:data][:id]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:name)
      expect(market[:data][:attributes][:name]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:street)
      expect(market[:data][:attributes][:street]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:city)
      expect(market[:data][:attributes][:city]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:county)
      expect(market[:data][:attributes][:county]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:state)
      expect(market[:data][:attributes][:state]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:zip)
      expect(market[:data][:attributes][:zip]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:lat)
      expect(market[:data][:attributes][:lat]).to be_an(String)
      
      expect(market[:data][:attributes]).to have_key(:lon)
      expect(market[:data][:attributes][:lon]).to be_an(String)

      expect(market[:data][:attributes]).to have_key(:lon)
      expect(market[:data][:attributes][:vendor_count]).to be_an(Integer)
    end

    it "Market by id returns a 404 response when market is not found" do
      get "/api/v0/markets/123123123123"

      expect(response).to have_http_status(404)

      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end