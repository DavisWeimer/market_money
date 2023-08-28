require "rails_helper"

RSpec.describe "Markets API" do
  describe "#GET" do
    it "all Markets" do
      create_list(:market, 10)
      
      get "/api/v0/markets"

      expect(response).to be_successful
    end
  end
end