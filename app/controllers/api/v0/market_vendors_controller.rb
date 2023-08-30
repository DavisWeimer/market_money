class Api::V0::MarketVendorsController < ApplicationController
  def index
    begin
      market = Market.find(params[:market_id])
      render json: { data: VendorSerializer.format_vendors(market.vendors) }
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  
end