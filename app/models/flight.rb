class Flight < ActiveRecord::Base
  attr_accessible :airline, :car_id, :flight_number, :flight_time, :traveler_name
  belongs_to :car

  def self.new_enough_flights
    Flight.where("flight_time > ?", DateTime.now - 1.day).order('flight_time ASC')
  end
end
