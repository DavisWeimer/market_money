require "rails_helper"

RSpec.describe "Markets API" do
  describe "#GET" do
    it "nearest ATM's", :vcr do
      market = create(:market, lat: "35.07904", lon: "-106.60068")
      
      get "/api/v0/markets/#{market.id}/nearest_atms"

      atms = JSON.parse(response.body, symbolize_names: true)

      atms[:data].each do |atm|
        expect(atm).to have_key(:id)
        expect(atm[:id]).to eq(nil)
        
        expect(atm[:attributes]).to have_key(:name)
        expect(atm[:attributes][:name]).to be_an(String)

        expect(atm[:attributes]).to have_key(:address)
        expect(atm[:attributes][:address]).to be_an(String)

        expect(atm[:attributes]).to have_key(:lat)
        expect(atm[:attributes][:lat]).to be_an(Float)

        expect(atm[:attributes]).to have_key(:lon)
        expect(atm[:attributes][:lon]).to be_an(Float)

        expect(atm[:attributes]).to have_key(:distance)
        expect(atm[:attributes][:distance]).to be_an(Float)
      end
    end

    it "nearest ATM's — GET fails if id is invalid" do
      get "/api/v0/markets/123123123123/nearest_atms"

      expect(response).to have_http_status(:not_found)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end