class Market < ApplicationRecord
  validates :name, :street, :city, :state, :zip, :lat, :lon, presence: true

  has_many :market_vendors
  has_many :vendors, through: :market_vendors
end