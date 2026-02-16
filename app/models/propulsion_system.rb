class PropulsionSystem < ApplicationRecord
  validates :name, presence: true
  validates :velocity_km_s, presence: true, numericality: { greater_than: 0 }

  SPEED_OF_LIGHT_KM_S = 299_792.458

  def velocity_fraction_c
    self[:velocity_fraction_c] || velocity_km_s / SPEED_OF_LIGHT_KM_S
  end

  def formatted_velocity
    if velocity_fraction_c >= 0.01
      "#{(velocity_fraction_c * 100).round(2)}% of light speed"
    else
      "#{velocity_km_s.round(1)} km/s"
    end
  end
end
