class Api::V0::VendorsController < ApplicationController
  def index
    render json: { data: VendorSerializer.format_vendors(Vendor.all) }
  end
end