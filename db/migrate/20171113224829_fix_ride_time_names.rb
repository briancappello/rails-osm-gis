class FixRideTimeNames < ActiveRecord::Migration[5.1]
  def change
    change_table :rides do |t|
      t.rename :start, :start_time
      t.rename :end, :end_time
    end
  end
end
