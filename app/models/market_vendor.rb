class MarketVendor < ApplicationRecord
  validates :market_id, :vendor_id, presence: true
  belongs_to :market
  belongs_to :vendor
end
