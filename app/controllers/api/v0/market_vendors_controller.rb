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
    rescue ActiveRecord::RecordNotFound
        render json: { errors: [{ detail: "Validation Failed: Vendor or Market must exist" }] }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      if e.message.include?('already exists')
        render json: { errors: [{ detail: "Validation Failed: Market vendor association between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists" }] }, status: :bad_request
      end
    end
  end
end