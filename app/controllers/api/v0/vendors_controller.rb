class Api::V0::VendorsController < ApplicationController
  def show
    begin
      render json: { data: VendorSerializer.format_vendor(Vendor.find(params[:id])) }
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end
end