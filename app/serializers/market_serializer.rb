class MarketSerializer
  def self.format_markets(markets)
    markets.map do |market|
      {
        id: market.id.to_s,
        type: "market",
        attributes: {
          name: market.name,
          street: market.street,
          city: market.city,
          county: market.county,
          state: market.state,
          zip: market.zip,
          lat: market.lat,
          lon: market.lon,
          vendor_count: market.vendors.count
        }
      }
    end
  end

  def self.format_market(market)
    {
      id: market.id.to_s,
      type: "market",
      attributes: {
        name: market.name,
        street: market.street,
        city: market.city,
        county: market.county,
        state: market.state,
        zip: market.zip,
        lat: market.lat,
        lon: market.lon,
        vendor_count: market.vendors.count
      }
    }
  end
end