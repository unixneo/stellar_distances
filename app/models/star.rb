class Star < ApplicationRecord
  validates :name, presence: true
  validates :distance_ly, presence: true, numericality: { greater_than: 0 }

  LIGHT_YEAR_KM = 9.461e12

  def distance_km
    self[:distance_km] || distance_ly * LIGHT_YEAR_KM
  end

  def formatted_distance
    if distance_ly >= 1_000_000
      "#{(distance_ly / 1_000_000.0).round(2)} million light years"
    elsif distance_ly >= 1000
      "#{distance_ly.round(0).to_s(:delimited)} light years"
    else
      "#{distance_ly.round(2)} light years"
    end
  end
end
