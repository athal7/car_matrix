class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle
  has_many :arrivals
  has_many :departures

  def self.reorganize
    Car.all.each do |car|
      car.car_seats.each do |cs|
        cs.destroy
      end
    end
    Arrival.all.each do |arr|
      arr.place_in_car
    end
    Departure.all.each do |dep|
      dep.place_in_car
    end
  end

  def arrival_works_with?(time)
    time = time.localtime.to_datetime
    puts time.inspect
    puts time.hour.inspect
    if name == 'Hotel Shuttle'
      if (time.hour == 15 && time.minute >= 30) || time.hour > 15
        return true
      else
        return false
      end
    end

    date = time.to_date
    date_arrivals = arrivals.select { |arr| arr.time.to_date == date }
    return if date_arrivals.count >= num_seats

    within_time = true
    date_arrivals.each do |arr|
      if arr.time > time + 30.minutes || arr.time < time - 30.minutes
        within_time = false
      end
    end
    within_time

  end

  def departure_works_with?(time)
    date = time.to_date
    date_departures = departures.select { |arr| arr.time.to_date == date }
    return if date_departures.count >= num_seats

    within_time = true
    date_departures.each do |arr|
      if arr.time > time + 30.minutes || arr.time < time - 30.minutes
        within_time = false
      end
    end
    within_time

  end
end
