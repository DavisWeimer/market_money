class NearestAtmService
  def self.conn
    Faraday.new(url: "https://api.tomtom.com/search/2/nearbySearch/.json?" ) do |faraday|
      faraday.params["key"] = Rails.application.credentials.tomtom_api_key[:key]
    end
  end

  def self.find_nearest_atms(lat, lon)
    response = conn.get do |req|
      req.url "", lat: lat, lon: lon
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end