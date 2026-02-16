class CreatePropulsionSystems < ActiveRecord::Migration[7.1]
  def change
    create_table :propulsion_systems do |t|
      t.string :name
      t.float :velocity_km_s
      t.float :velocity_fraction_c
      t.text :description
      t.string :technology_readiness

      t.timestamps
    end
  end
end
