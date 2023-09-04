require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
    it { should allow_value(true).for(:credit_accepted) }
    it { should allow_value(false).for(:credit_accepted) }
    it { should_not allow_value(nil).for(:credit_accepted) }
  end

  describe "relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe "instance methods" do
    it "#states_finder" do
      vendor = create(:vendor)
      markets = create_list(:market, 3)
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: vendor.id)
      end
      expect(vendor.states_finder).to be_an(Array)
      expect(vendor.states_finder[0]).to be_an(String)
    end
  end
end
