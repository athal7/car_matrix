class FixArrivalDeparture < ActiveRecord::Migration
  def change
    add_column :arrivals, :car_id, :integer
    add_column :arrivals, :airline, :string
    add_column :arrivals, :flight_number, :string
    add_column :departures, :car_id, :integer
    add_column :departures, :airline, :string
    add_column :departures, :flight_number, :string
  end

end
