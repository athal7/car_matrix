class Flight < ActiveRecord::Base
  attr_accessible :airline, :car_id, :flight_number, :flight_time, :traveler_name
  belongs_to :car

  def self.new_enough_flights
    Flight.where("flight_time > ?", DateTime.now - 1.day).order('flight_time ASC')
  end

  def arrival?
    flight_time.monday?
  end

  def eligible_for_shuttle?
    flight_time.monday? && ((flight_time.hour == 15 && flight_time.min >= 30) || flight_time.hour > 15)
  end
end
