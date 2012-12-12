class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle
  has_many :flights
  after_save :reorganize
  MAX_FLIGHT_DIFFERENCE=30
  FUTURE_DISPLAY_DATES=5
  PAST_DISPLAY_DATES=1

  def self.displayed_flight_dates
    Car.includes(:flights).flat_map(&:displayed_flight_dates).uniq.sort!
  end

  def self.reorganize
    flights.each { |fl| fl.update_attribute(:car_id, nil) }
    put_flights_in_car
    spread_out_flights
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
    flights.each do |flight|
      car = Car.all.detect{|c| c.works_with?(flight)}
      car ? car.flights << flight : Car.last.flights << flight
    end
  end

  def self.spread_out_flights
    Flight.flight_dates.each do |flight_date|
      if (cars_for_date(flight_date).uniq.size < Car.all.size)
        cars_with_no_flights_for_date(flight_date).each do |car|
          if cars_with_multiple_flights_for_date(flight_date).present?
            cars_with_multiple_flights_for_date(flight_date).last.flights.last.update_attribute(:car_id, car.id)
          end
        end
      end
    end
  end

  def self.cars_for_date(date)
    flights.select{|fl| fl.flight_time.to_date == date }.map(&:car)
  end

  def self.cars_with_no_flights_for_date(date)
    (Car.all.to_a - cars_for_date(date)).reject(&:shuttle)
  end

  def self.cars_with_multiple_flights_for_date(date)
    cars_for_date(date).select{|car| cars_for_date(date).count(car) > 1}.uniq
  end

  def self.flights
    Flight.new_enough_flights
  end

  def self.shuttle
    Car.where(:shuttle => true).first
  end

  def close_enough(flight1, flight2)
    flight1.flight_time > flight2.flight_time - MAX_FLIGHT_DIFFERENCE.minutes && flight1.flight_time < flight2.flight_time + MAX_FLIGHT_DIFFERENCE.minutes
  end

end
