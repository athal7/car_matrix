class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.integer :car_id
      t.string :traveler_name
      t.string :flight_number
      t.string :airline
      t.datetime :flight_time
      t.boolean :arrival, :default => false

      t.timestamps
    end
  end
end
