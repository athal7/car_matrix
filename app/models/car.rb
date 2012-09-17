class Car < ActiveRecord::Base
  attr_accessible :name, :num_seats, :shuttle
  has_many :flights
  after_save :reorganize

  def self.grouped_cars_with_flights
    all_flight_dates = Car.all.flat_map(&:flight_dates).uniq
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
      else
        Car.all.detect{|c| c.works_with?(fl)}.flights << fl
      end
    end
  end

  def works_with?(flight)
    time = flight.flight_time.to_datetime
    if shuttle
      if ((time.hour == 15 && time.minute >= 30) || time.hour > 15) && time.monday?
        return true
      else
        return false
      end
    else
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

  end

  def flight_dates
    flights.select{|fl| fl.flight_time.to_date > Date.today - 1}.map{|fl| fl.flight_time.to_date}.uniq

  end

  def reorganize
    Car.reorganize
  end
end
