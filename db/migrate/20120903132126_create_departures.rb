class CreateDepartures < ActiveRecord::Migration
  def change
    create_table :departures do |t|
      t.string :traveler_name
      t.datetime :time

      t.timestamps
    end
  end
end
