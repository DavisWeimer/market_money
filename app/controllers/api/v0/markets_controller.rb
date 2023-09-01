require 'pry'

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

  def search
    if invalid_parameters?
      render json: { errors: [{ detail: "Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint." }] }, status: :unprocessable_entity
    else
      markets = Market.build_search_query(search_hash).to_a
      if markets.empty?
        render json: { data: [] }, status: :ok
      else
        render json: { data: MarketSerializer.format_markets(markets) }, status: :ok
      end
    end
  end

  def nearest_atms
    begin
      market = Market.find(params[:id])

      atms = NearestAtmFacade.nearest_atms(market.lat, market.lon).compact
      
      render json: { data: AtmSerializer.format_atms(atms) }, status: :ok

    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end

  
  private
  def market_params
    params.require(:market).permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end

  def search_hash
  permitted_params = params.permit(:state, :city, :name)
  permitted_params.to_h.transform_values(&:titleize).symbolize_keys
  end
  
  def invalid_parameters?
    
    invalid_combinations = [
      [:city],
      [:city, :name]
    ]
    
    valid_combinations = [
      [:state],
      [:state, :city],
      [:state, :city, :name],
      [:state, :name],
      [:name]
    ]

    invalid_combinations.any? { |combination| search_hash.keys.sort == combination.sort } ||
    valid_combinations.none? { |combination| search_hash.keys.sort == combination.sort }
  end
end