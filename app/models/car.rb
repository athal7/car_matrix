class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle
  has_many :flights
  after_save :reorganize

  def self.grouped_cars_with_flights
    all_flight_dates = Car.all.flat_map(&:displayed_flight_dates).uniq
    all_flight_dates.sort!.flat_map do |date|
      { date => Car.all.flat_map do |c|
        { c => c.flights.select {|fl| fl.flight_time.to_date == date }}
      end
      }
    end
  end

  def self.reorganize
    flights = Flight.all.sort_by(&:flight_time)
    shuttle = Car.where(:shuttle => true).first
    flights.each do |fl|
      fl.update_attribute(:car_id, nil)
    end
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

  def works_with?(flight)
    if shuttle
      flight.eligible_for_shuttle? ? true : false
    else
      date_flights = flights.select { |fl| fl.flight_time.to_date == flight.flight_time.to_date }
      return if date_flights.count >= num_seats

      date_flights.each do |fl|
        if fl.flight_time > flight.flight_time + 30.minutes || fl.flight_time < flight.flight_time - 30.minutes
          return false
        end
      end
      true
    end

  end

  def displayed_flight_dates
    flights.select{|fl| fl.flight_time.to_date > Date.today - 1 && fl.flight_time.to_date < Date.today + 5}.map{|fl| fl.flight_time.to_date}.uniq
  end

  def reorganize
    Car.reorganize
  end
end
