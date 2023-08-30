require "rails_helper"

RSpec.describe "Market Vendors API" do
  describe "#CREATE" do
    it "creates MarketVendor" do
      vendor_params = attributes_for(:vendor)
      post "/api/v0/vendors", params: { vendor: vendor_params }
    end


  end
end