class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle
  has_many :flights

  def self.grouped_cars_with_flights
    all_flight_dates = Car.all.flat_map(&:flight_dates).uniq
    all_flight_dates.map do |date|
      { date => Car.all.map do |c|
        { c.name => c.flights}
      end
      }
    end
  end

  def self.reorganize
    Flight.all.each do |fl|
      fl.update_attribute(:car_id, nil)
      fl.place_in_car
    end
  end

  def works_with?(flight)
    time = flight.flight_time.localtime.to_datetime
    puts "****************"
    puts flight.traveler_name
    puts time.hour.inspect
    puts shuttle.inspect
    puts name
    puts flight.arrival.inspect
    if shuttle
      if flight.arrival && ((time.hour == 15 && time.minute >= 30) || time.hour > 15)
        return true
      else
        return false
      end
    end

    # FIXME FOR ACTIVERECORD TIME ISSUES
    date = time.to_date
    date_flights = flights.select { |fl| fl.flight_time.to_date == date }
    return if date_flights.count >= num_seats

    within_time = true
    date_flights.each do |fl|
      if fl.flight_time > time + 30.minutes || fl.flight_time < time - 30.minutes
        within_time = false
      end
    end
    within_time

  end

  def flight_dates
    flights.select{|fl| fl.flight_time.localtime.to_date > Date.today}.map{|fl| fl.flight_time.localtime.to_date}.uniq

  end
end
