require 'rails_helper'

RSpec.describe Market, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe "relationships" do
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe "class methods" do
    it ".build_search_query(search_hash)" do
      markets = create_list(:market, 5, state: "Colorado")
      search_hash = {:state=>"Colorado"}

      market_search ||= Market.build_search_query(search_hash)
      
      expect(market_search).to be_an(Array)
      expect(market_search.count).to eq(5)
    end
  end
end
