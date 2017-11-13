class CreateRides < ActiveRecord::Migration[5.1]
  def change
    create_table :rides do |t|
      t.references :user, foreign_key: true
      t.references :trail, foreign_key: true

      t.datetime :start
      t.datetime :end

      t.string :gpx_file

      t.timestamps
    end
  end
end
