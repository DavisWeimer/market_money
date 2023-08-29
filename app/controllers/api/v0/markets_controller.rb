class Api::V0::MarketsController < ApplicationController
  def index
    render json: { data: MarketSerializer.format_markets(Market.all) }
  end

  def show
    begin
      render json: { data: MarketSerializer.format_market(Market.find(params[:id])) }
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: 404
    end
  end
end