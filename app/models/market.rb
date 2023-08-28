class Market < ApplicationRecord
  validates :name, :street, :city, :state, :zip, :lat, :lon, presence: true
end