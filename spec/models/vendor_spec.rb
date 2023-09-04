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

  describe "class methods" do
    before :each do
      @national_vendor = create(:vendor)
      markets = create_list(:market, 15)
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: @national_vendor.id)
      end

      @national_vendor_2 = create(:vendor)
      markets = create_list(:market, 4)
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: @national_vendor_2.id)
      end

      @local_vendor = create(:vendor)
      markets = create_list(:market, 3, state: "Colorado")
      markets.each do |market|
        MarketVendor.create!(market_id: market.id, vendor_id: @local_vendor.id)
      end
    end

    it ".selling_national" do
      expect(Vendor.selling_national.to_a).to be_an(Array)
      expect(Vendor.selling_national.map(&:id)).not_to include(@local_vendor.id)
    end

    it ".count_of_national" do
      expect(Vendor.count_of_national).to eq(2)
    end
  end
end
