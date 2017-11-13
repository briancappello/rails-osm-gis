class CreateWaypoints < ActiveRecord::Migration[5.1]
  def change
    create_table :waypoints do |t|
      t.float :lat
      t.float :lon
      t.text :description
      t.references :ride, foreign_key: true

      t.timestamps
    end
    add_index :waypoints, [:lat, :lon, :ride_id], unique: true
  end
end
