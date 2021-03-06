class Flight < ActiveRecord::Base
  attr_accessible :airline, :car_id, :flight_number, :flight_time, :traveler_name
  belongs_to :car

  def self.new_enough_flights
    Flight.where("flight_time > ?", DateTime.now - 1.day).order('flight_time ASC')
  end

  def self.flight_dates
    new_enough_flights.map {|fl| fl.flight_time.to_date}
  end

  def self.flights_for_date(date)
    Flight.all.select{|fl| fl.flight_time.to_date == date}
  end

  def arrival?
    # flight_time.monday? || flight_time.tuesday? || flight_time.wednesday?
    true
  end

  def eligible_for_shuttle?
    # arrival? && ((flight_time.hour == 15 && flight_time.min >= 30) || flight_time.hour > 15)
    true
  end
end
