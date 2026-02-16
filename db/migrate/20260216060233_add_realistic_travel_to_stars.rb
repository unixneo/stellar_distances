class AddRealisticTravelToStars < ActiveRecord::Migration[7.1]
  def change
    add_column :stars, :realistic_travel_days, :float
    add_column :stars, :realistic_travel_notes, :text
  end
end
