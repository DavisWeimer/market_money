require "rails_helper"

RSpec.describe "Market API" do
  describe "#CREATE" do
    it "creates Market" do
      market_params = attributes_for(:market)

      post "/api/v0/markets", params: { market: market_params }

      expect(response).to have_http_status(:created)

      new_market = JSON.parse(response.body, symbolize_names: true)
      
      expect(new_market[:data][0]).to have_key(:id)
      expect(new_market[:data][0][:id]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:name)
      expect(new_market[:data][0][:attributes][:name]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:street)
      expect(new_market[:data][0][:attributes][:street]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:city)
      expect(new_market[:data][0][:attributes][:city]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:county)
      expect(new_market[:data][0][:attributes][:county]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:state)
      expect(new_market[:data][0][:attributes][:state]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:zip)
      expect(new_market[:data][0][:attributes][:zip]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:lat)
      expect(new_market[:data][0][:attributes][:lat]).to be_an(String)
      
      expect(new_market[:data][0][:attributes]).to have_key(:lon)
      expect(new_market[:data][0][:attributes][:lon]).to be_an(String)
    end

    it "create Market — CREATE fails if any datafields are blank" do
      market_params = {
                        name: "Gary Renewables & Environment",
                        street:  "Quinton Ville",
                        city: "Gladden River",
                        county: "Autumn Court",
                        state: "Kadath",
                        zip: "43202"
                      }
      post "/api/v0/markets", params: { market: market_params }

      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail][0]).to eq("Lat can't be blank")
      expect(error[:errors][0][:detail][1]).to eq("Lon can't be blank")
    end
  end
end