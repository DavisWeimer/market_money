class Vendor < ApplicationRecord
  validates :name, :description, :contact_name, :contact_phone, presence: true
  validates :credit_accepted, inclusion: { in: [true, false] }

  has_many :market_vendors
  has_many :markets, through: :market_vendors

  def states_finder
    markets.select(:state).distinct.pluck(:state)
  end

  def self.selling_national
    select('vendors.*, COUNT(DISTINCT markets.state) AS state_count')
      .joins(:markets)
      .group('vendors.id')
      .having('COUNT(DISTINCT markets.state) > 1')
  end

  def self.count_of_national
    selling_national.length
  end
end
