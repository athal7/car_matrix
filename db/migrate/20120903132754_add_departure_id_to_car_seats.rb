class AddDepartureIdToCarSeats < ActiveRecord::Migration
  def change
    add_column :car_seats, :departure_id, :integer
  end
end
