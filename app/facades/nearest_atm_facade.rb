class NearestAtmFacade
  def self.nearest_atms(lat, lon)
    NearestAtmService.find_nearest_atms(lat, lon)[:results].map do |atm_data|
      if atm_data[:poi][:categories] == ["cash dispenser"]
        NearestAtm.new(atm_data)
      end
    end
  end
end