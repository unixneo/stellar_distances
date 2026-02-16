class CreateStars < ActiveRecord::Migration[7.1]
  def change
    create_table :stars do |t|
      t.string :name
      t.float :distance_ly
      t.float :distance_km
      t.string :constellation
      t.string :star_type
      t.text :notes

      t.timestamps
    end
  end
end
