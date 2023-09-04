class Api::V0::VendorsController < ApplicationController
  def create
    vendor = Vendor.new(vendor_params)
    if vendor.save
      render json: { data: VendorSerializer.format_vendor(vendor) }, status: :created
    else
      vendor_bad_request(vendor)
    end
  end

  def update
    begin
      vendor = Vendor.find(params[:id])
      if vendor.update(vendor_params)
        render json: { data: VendorSerializer.format_vendor(vendor) }, status: :ok
      else
        vendor_bad_request(vendor)
      end
    rescue StandardError => e
      vendor_not_found(e)
    end
  end
  
  def show
    begin
      render json: { data: VendorSerializer.format_vendor(Vendor.find(params[:id])) }
    rescue StandardError => e
      vendor_not_found(e)
    end
  end

  def destroy
    begin
      vendor = Vendor.find(params[:id])
      if vendor.destroy
        render json: {}, status: :no_content
      else
        vendor_bad_request(vendor)
      end
    rescue ActiveRecord::RecordNotFound => e
      vendor_not_found(e)
    end
  end

  def multiple_states
    begin
      vendors ||= Vendor.selling_national
      vendors_count = vendors.count_of_national
      render json: { results: vendors_count , data: VendorSerializer.format_vendors(vendors) }
    rescue StandardError => e
      vendor_not_found(e)
    end
  end
  
  private
  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def vendor_not_found(e)
    render json: { errors: [{ detail: e.message }] }, status: :not_found
  end

  def vendor_bad_request(vendor)
    render json: { errors: [{ detail: vendor.errors.full_messages }] }, status: :bad_request
  end
end