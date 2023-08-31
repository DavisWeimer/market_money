require "rails_helper"

RSpec.describe "Vendors API" do
  before :each do
    vendor_params = attributes_for(:vendor)
    post "/api/v0/vendors", params: { vendor: vendor_params }
    @new_vendor = JSON.parse(response.body, symbolize_names: true)
  end
  
  describe "#PATCH" do
    it "updates Vendor" do
      vendor_params = {
                      contact_name: "Kimberly Couwer",
                      contact_phone: "(184) 976-2283"
                      }
      patch "/api/v0/vendors/#{@new_vendor[:data][0][:id]}", params: { vendor: vendor_params }
      expect(response).to have_http_status(:ok)
      
      updated_vendor = JSON.parse(response.body, symbolize_names: true)
      expect(updated_vendor[:data][0][:attributes][:contact_name]).to eq("Kimberly Couwer")
      expect(updated_vendor[:data][0][:attributes][:contact_phone]).to eq("(184) 976-2283")
    end

    it "updates Vendor — UPDATE fails if id invalid " do
      vendor_params = {
        contact_name: "Kimberly Couwer",
        contact_phone: "(184) 976-2283"
        }
      patch "/api/v0/vendors/123123123123", params: { vendor: vendor_params }
      
      expect(response).to have_http_status(:not_found)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
    end

    it "updates Vendor — UPDATE fails if any datafields are blank " do
      vendor_params = {
        contact_name: "",
        contact_phone: "(184) 976-2283"
        }
      patch "/api/v0/vendors/#{@new_vendor[:data][0][:id]}", params: { vendor: vendor_params }
      
      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail][0]).to eq("Contact name can't be blank")
    end
  end
end