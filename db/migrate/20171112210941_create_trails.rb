class CreateTrails < ActiveRecord::Migration[5.1]
  def change
    create_table :trails do |t|
      t.string :name
      t.references :location, foreign_key: true

      t.timestamps
    end
    add_index :trails, :name
    add_index :trails, [:name, :location_id], unique: true
  end
end
