class Api::V0::VendorsController < ApplicationController
  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: { data: VendorSerializer.format_vendor(vendor) }, status: :created
    else
      render json: { errors: [{ detail: vendor.errors.full_messages }] }, status: :bad_request
    end
  end
  
  def show
    begin
      render json: { data: VendorSerializer.format_vendor(Vendor.find(params[:id])) }
    rescue StandardError => e
      render json: { errors: [{ detail: e.message }] }, status: :not_found
    end
  end
  
  private
  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end