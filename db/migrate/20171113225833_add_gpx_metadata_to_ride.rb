class AddGpxMetadataToRide < ActiveRecord::Migration[5.1]
  def change
    change_table :rides do |t|
      t.integer :duration
      t.integer :moving_duration
      t.float :distance
      t.float :avg_speed
    end
  end
end
