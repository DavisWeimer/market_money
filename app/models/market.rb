class Market < ApplicationRecord
  validates :name, :street, :city, :state, :zip, :lat, :lon, presence: true

  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def self.build_search_query(search_hash)
    query = self.all

    query = query.where(name: search_hash[:name]) if search_hash.key?(:name)
    query = query.where(city: search_hash[:city]) if search_hash.key?(:city)
    query = query.where(state: search_hash[:state]) if search_hash.key?(:state)
    
    query
  end
end