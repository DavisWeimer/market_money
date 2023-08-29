require "rails_helper"

RSpec.describe "Market Vendors API" do
  describe "#GET" do

    it "Vendors for a market" do
      market = create(:market)
      factory_vendors = create_list(:vendor, 20)
      market.vendors.push(factory_vendors)

      get "/api/v0/markets/#{market.id}/vendors"

      expect(response).to have_http_status(200)
      expect(response).to be_successful

      market = JSON.parse(response.body, symbolize_names: true)

      market[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:name)
        expect(market[:attributes][:name]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:description)
        expect(market[:attributes][:description]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:contact_name)
        expect(market[:attributes][:contact_name]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:contact_phone)
        expect(market[:attributes][:contact_phone]).to be_an(String)
        
        expect(market[:attributes]).to have_key(:credit_accepted)
        expect(market[:attributes][:credit_accepted]).to be_an(TrueClass).or be_an(FalseClass)
      end
    end

    it "Vendors for a market — bad integer id returns 404" do
      get "/api/v0/markets/123123123123/vendors"

      expect(response).to have_http_status(404)

      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error[:errors][0][:detail]).to eq("Couldn't find Market with 'id'=123123123123")
    end
  end
end