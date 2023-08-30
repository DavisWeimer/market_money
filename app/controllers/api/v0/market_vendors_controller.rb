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

      if MarketVendor.exists?(vendor_id: vendor.id, market_id: market.id)
        render json: { errors: [{ detail: "Validation Failed: Market vendor association between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists" }] }, status: :unprocessable_entity
        return
      end
      
      market_vendor = MarketVendor.new(vendor: vendor, market: market)
      
      if market_vendor.save
        render json: { message: "Successfully added vendor to market" }, status: :created
      end
    rescue ActiveRecord::RecordNotFound
        render json: { errors: [{ detail: "Validation Failed: Vendor or Market must exist" }] }, status: :not_found
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])

    if market_vendor
      market_vendor.destroy
      render json: {}, status: :no_content
    else
      render json: { errors: [{ detail: "No MarketVendor with market_id=#{params[:market_id]} AND vendor_id=#{params[:vendor_id]} exists" }] }, status: :not_found
    end
  end
end