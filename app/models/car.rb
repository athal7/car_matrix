class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle
  has_many :flights
  after_save :reorganize
  MAX_FLIGHT_DIFFERENCE=30
  FUTURE_DISPLAY_DATES=5
  PAST_DISPLAY_DATES=1

  def self.displayed_flight_dates
    Car.all.flat_map(&:displayed_flight_dates).uniq.sort!
  end


  def self.reorganize
    flights.each { |fl| fl.update_attribute(:car_id, nil) }
    put_flights_in_car
  end

  def displayed_flight_dates
    valid_flights = flights.select do |fl|
      fl.flight_time.to_date > Date.today - PAST_DISPLAY_DATES && fl.flight_time.to_date < Date.today + FUTURE_DISPLAY_DATES
    end
    valid_flights.map { |fl| fl.flight_time.to_date }.uniq
  end

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

  def reorganize
    Car.reorganize
  end

  private

  def self.put_flights_in_car
    flights.each do |fl|
      if shuttle.works_with?(fl)
        shuttle.flights << fl
      elsif car = Car.all.detect{|c| c.works_with?(fl)}
        car.flights << fl
      else
        Car.last.flights << fl
      end
    end
  end

  def self.flights
    Flight.all.sort_by(&:flight_time)
  end

  def self.shuttle
    Car.where(:shuttle => true).first
  end

  def close_enough(flight1, flight2)
    flight1.flight_time > flight2.flight_time - MAX_FLIGHT_DIFFERENCE.minutes && flight1.flight_time < flight2.flight_time + MAX_FLIGHT_DIFFERENCE.minutes
  end

end
