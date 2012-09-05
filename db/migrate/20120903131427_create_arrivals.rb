class CreateArrivals < ActiveRecord::Migration
  def change
    create_table :arrivals do |t|
      t.string :traveler_name
      t.datetime :time

      t.timestamps
    end
  end
end
