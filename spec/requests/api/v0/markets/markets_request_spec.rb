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

      expect(market[:data][0]).to have_key(:id)
      expect(market[:data][0][:id]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:name)
      expect(market[:data][0][:attributes][:name]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:street)
      expect(market[:data][0][:attributes][:street]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:city)
      expect(market[:data][0][:attributes][:city]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:county)
      expect(market[:data][0][:attributes][:county]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:zip)
      expect(market[:data][0][:attributes][:zip]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:lat)
      expect(market[:data][0][:attributes][:lat]).to be_an(String)
      
      expect(market[:data][0][:attributes]).to have_key(:lon)
      expect(market[:data][0][:attributes][:lon]).to be_an(String)

      expect(market[:data][0][:attributes]).to have_key(:lon)
      expect(market[:data][0][:attributes][:vendor_count]).to be_an(Integer)
    end

    it "Market by id — returns a 404 response when market is not found" do
      get "/api/v0/markets/123123123123"

      expect(response).to have_http_status(404)

      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end

  describe "#GET — SEARCH VALID" do
    it "can search by query params — Valid params but Market doesn't exist" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])

      get "/api/v0/markets/search", params: { city: "Denver", state: "colorado", name: "Goodtimes" }

      expect(response).to have_http_status(:ok)
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data]).to eq([])
    end

    it "can search by query params — Valid params State" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])

      get "/api/v0/markets/search", params: { state: "new Mexico" }

      expect(response).to have_http_status(:ok)
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to eq("New Mexico")
    end

    it "can search by query params — Valid params State and City" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])

      get "/api/v0/markets/search", params: { state: "new Mexico", city: "albuquerque" }

      expect(response).to have_http_status(:ok)
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data][0][:attributes]).to have_key(:city)
      expect(market[:data][0][:attributes][:city]).to eq("Albuquerque")

      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to eq("New Mexico")
    end

    it "can search by query params — Valid params City, State, and Name" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])

      get "/api/v0/markets/search", params: { city: "albuquerque", state: "new Mexico", name: "Nob hil" }

      expect(response).to have_http_status(:ok)
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data][0][:attributes]).to have_key(:name)
      expect(market[:data][0][:attributes][:name]).to eq("Nob Hil")
      
      expect(market[:data][0][:attributes]).to have_key(:city)
      expect(market[:data][0][:attributes][:city]).to eq("Albuquerque")
      
      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to eq("New Mexico")
    end

    it "can search by query params — Valid params Name" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])

      get "/api/v0/markets/search", params: { name: "Nob hil" }

      expect(response).to have_http_status(:ok)
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data][0][:attributes]).to have_key(:name)
      expect(market[:data][0][:attributes][:name]).to eq("Nob Hil")
      
      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to eq("New Mexico")
    end

    it "can search by query params — Valid params State and Name" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])

      get "/api/v0/markets/search", params: { state: "new Mexico", name: "Nob hil" }

      expect(response).to have_http_status(:ok)
      market = JSON.parse(response.body, symbolize_names: true)

      expect(market[:data][0][:attributes]).to have_key(:name)
      expect(market[:data][0][:attributes][:name]).to eq("Nob Hil")
      
      expect(market[:data][0][:attributes]).to have_key(:state)
      expect(market[:data][0][:attributes][:state]).to eq("New Mexico")
    end
  end

  describe "#GET — SEARCH INVALID" do
    it "cannot search by query params — Invalid params City" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])
      get "/api/v0/markets/search", params: { city: "albuquerque" }

      expect(response).to have_http_status(:unprocessable_entity)
      
      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end

    it "cannot search by query params — Invalid params City" do
      markets = create_list(:market, 5)
      markets.concat([create(:market, city: "Albuquerque", state: "New Mexico", name: "Nob Hil", )])
      get "/api/v0/markets/search", params: { city: "albuquerque", name: "nob hil" }

      expect(response).to have_http_status(:unprocessable_entity)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end
end