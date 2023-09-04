require "rails_helper"

RSpec.describe "Vendors API" do
  describe "#GET" do
    it "Vendor by id" do
      id = create(:vendor).id

      get "/api/v0/vendors/#{id}"

      expect(response).to have_http_status(200)
      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)

      expect(vendor[:data][0]).to have_key(:id)
      expect(vendor[:data][0][:id]).to be_an(String)
      
      expect(vendor[:data][0][:attributes]).to have_key(:name)
      expect(vendor[:data][0][:attributes][:name]).to be_an(String)
      
      expect(vendor[:data][0][:attributes]).to have_key(:description)
      expect(vendor[:data][0][:attributes][:description]).to be_an(String)
      
      expect(vendor[:data][0][:attributes]).to have_key(:contact_name)
      expect(vendor[:data][0][:attributes][:contact_name]).to be_an(String)
      
      expect(vendor[:data][0][:attributes]).to have_key(:contact_phone)
      expect(vendor[:data][0][:attributes][:contact_phone]).to be_an(String)
      
      expect(vendor[:data][0][:attributes]).to have_key(:credit_accepted)
      expect(vendor[:data][0][:attributes][:credit_accepted]).to be_an(TrueClass).or be_an(FalseClass)
    end

    it "Vendor by id — bad integer id returns 404" do
      get "/api/v0/vendors/12313524756238"

      expect(response).to have_http_status(404)

      error = JSON.parse(response.body, symbolize_names: true)
      
      expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=12313524756238")
    end

    it "#states_sold_in" do
      id = create(:vendor).id
      markets = create_list(:market, 3)
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: id)
      end

      get "/api/v0/vendors/#{id}"
      
      expect(response).to have_http_status(200)
      expect(response).to be_successful
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor[:data][0][:attributes]).to have_key(:states_sold_in)
      expect(vendor[:data][0][:attributes][:states_sold_in]).to be_an(Array)
    end
  end
end