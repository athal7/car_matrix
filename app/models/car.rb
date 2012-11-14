class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle, :project_id
  has_many :flights
  belongs_to :project


  def flights_for_date(date)
    flights.select { |fl| fl.flight_time.to_date == date }.sort_by(&:flight_time)
  end

  def works_with?(flight)
    return flight.eligible_for_shuttle? if shuttle
    date_flights = flights_for_date(flight.flight_time.to_date)
    return false if date_flights.count >= num_seats
    date_flights.each { |fl| return false unless close_enough(fl, flight) }
    true
  end

  private

  def close_enough(flight1, flight2)
    flight1.flight_time > flight2.flight_time - project.max_flight_difference.minutes && flight1.flight_time < flight2.flight_time + project.max_flight_difference.minutes
  end

end
