class Api::V0::MarketsController < ApplicationController
  def index
    render json: { data: MarketSerializer.format_markets(Market.all) }
  end

  def show
    begin
      render json: { data: MarketSerializer.format_market(Market.find(params[:id])) }
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  def create
    market = Market.new(market_params)
    if market.save
      render json: { data: MarketSerializer.format_market(market) }, status: :created
    else
      render json: { errors: [{ detail: market.errors.full_messages }] }, status: :bad_request
    end
  end

  private
  def market_params
    params.require(:market).permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end
end