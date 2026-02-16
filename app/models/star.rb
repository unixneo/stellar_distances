class Star < ApplicationRecord
  validates :name, presence: true
  validates :distance_ly, presence: true, numericality: { greater_than: 0 }

  LIGHT_YEAR_KM = 9.461e12

  def distance_km
    self[:distance_km] || distance_ly * LIGHT_YEAR_KM
  end

  def formatted_distance
    km = self[:distance_km] || distance_ly * LIGHT_YEAR_KM
    
    # Solar system objects - show in km
    if distance_ly < 0.001
      if km >= 1_000_000_000
        "#{(km / 1_000_000_000.0).round(1)} billion km"
      elsif km >= 1_000_000
        "#{(km / 1_000_000.0).round(1)} million km"
      else
        "#{km.round(0).to_fs(:delimited)} km"
      end
    elsif distance_ly >= 1_000_000
      "#{(distance_ly / 1_000_000.0).round(2)} million ly"
    elsif distance_ly >= 1000
      "#{distance_ly.round(0).to_fs(:delimited)} ly"
    else
      "#{distance_ly.round(2)} ly"
    end
  end
  
  def solar_system?
    constellation == "Solar System"
  end
end
