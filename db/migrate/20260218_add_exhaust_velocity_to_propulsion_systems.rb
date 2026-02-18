class AddExhaustVelocityToPropulsionSystems < ActiveRecord::Migration[7.1]
  def change
    add_column :propulsion_systems, :exhaust_velocity_km_s, :float
  end
end
