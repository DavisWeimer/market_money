require "rails_helper"

RSpec.describe "Market Vendors API" do
  describe "#CREATE" do
    it "a Vendor" do
      vendor_params = attributes_for(:vendor, 
                                    name: "Semiconductive Golden Bakery", 
                                    description: "SVIs mission is to deliver quality products at affordable prices to our independent retailers, wholesalers and food service partners around the world by providing international procurement, distribution, marketing and supply chain management.", 
                                    contact_name: "Youthful Heidi", 
                                    contact_phone: "544-061-3183", 
                                    credit_accepted: false
                                    )
      post "/api/v0/vendors", params: { vendor: vendor_params }
      
      expect(response).to have_http_status(:created)

      new_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(new_vendor[:data][:attributes][:name]).to eq("Semiconductive Golden Bakery")
      expect(new_vendor[:data][:attributes][:description]).to eq("SVIs mission is to deliver quality products at affordable prices to our independent retailers, wholesalers and food service partners around the world by providing international procurement, distribution, marketing and supply chain management.")
      expect(new_vendor[:data][:attributes][:contact_name]).to eq("Youthful Heidi")
      expect(new_vendor[:data][:attributes][:contact_phone]).to eq("544-061-3183")
      expect(new_vendor[:data][:attributes][:credit_accepted]).to eq(false)
    end

    it "a Vendor — CREATE fails if any datafields are blank " do
      vendor_params = {
                      name: "Semiconductive Golden Bakery",
                      description: "SVIs mission is to deliver quality products at affordable prices to our independent retailers, wholesalers and food service partners around the world by providing international procurement, distribution, marketing and supply chain management.",
                      credit_accepted: false
                      }
      
      post "/api/v0/vendors", params: { vendor: vendor_params }
      
      expect(response).to have_http_status(:bad_request)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors][0][:detail][0]).to eq("Contact name can't be blank")
      expect(error[:errors][0][:detail][1]).to eq("Contact phone can't be blank")
    end
  end
end