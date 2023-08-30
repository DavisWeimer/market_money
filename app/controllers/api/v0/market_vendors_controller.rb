class Api::V0::MarketVendorsController < ApplicationController
  def index
    begin
      market = Market.find(params[:market_id])
      render json: { data: VendorSerializer.format_vendors(market.vendors) }
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def create
    begin
      market = Market.find(params[:market])
      vendor = Vendor.find(params[:vendor])

      market_vendor = MarketVendor.new(vendor: vendor, market: market)
      if market_vendor.save
        render json: { message: "Successfully added vendor to market" }, status: :created
      end
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    rescue StandardError => e
      render json: { errors: [{ detail: "Vendor or Market not found" }] }, status: :not_found
    end
  end
end