class CreatePictures < ActiveRecord::Migration[5.1]
  def change
    create_table :pictures do |t|
      t.string :title
      t.string :caption
      t.text :description
      t.string :file

      t.references :waypoint, foreign_key: true

      t.timestamps
    end
    add_index :pictures, [:title, :waypoint_id], unique: true
  end
end
