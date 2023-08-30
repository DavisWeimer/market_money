require "rails_helper"

RSpec.describe "Market Vendors API" do
  before :each do
    vendor_params = attributes_for(:vendor)
    post "/api/v0/vendors", params: { vendor: vendor_params }
    @new_vendor = JSON.parse(response.body, symbolize_names: true)
  end

  describe "#DELETE" do
    it "deletes Vendor" do
      expect(Vendor.all.count).to eq(1)

      delete "/api/v0/vendors/#{@new_vendor[:data][:id]}"
      
      expect(response).to have_http_status(:no_content)
      expect(Vendor.all.count).to eq(0)
    end

    it "deletes Vendor — DELETE fails if id invalid" do
      delete "/api/v0/vendors/123123123123"
      
      expect(response).to have_http_status(:not_found)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end
  end
end