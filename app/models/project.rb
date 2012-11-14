class Project < ActiveRecord::Base
  attr_accessible :name, :timezone, :max_flight_difference, :future_display_dates, :past_display_dates
  has_many :flights
  has_many :cars

  def displayed_flight_dates
    flight_dates = flights.map{|flight| flight.flight_time.to_date}
    flight_dates.select do |date|
      date > (Date.today - past_display_dates) && date < (Date.today + future_display_dates)
    end.uniq.sort!
  end

  def reorganize
    flights.each do |fl|
      return false unless fl.update_attribute(:car_id, nil)
    end
    return false unless put_flights_in_car
    true
  end

  def put_flights_in_car
    flights.each do |flight|
      car = cars.detect{|c| c.works_with?(flight)}
      if car
        return false unless car.flights << flight
      else
        return false unless car.last.flights << flight
      end
    end
    true
  end

  def new_enough_flights
    flights.select { |flight| flight.flight_time.to_date > (Date.today - past_display_dates) }.sort_by(&:flight_time)
  end

  def shuttle
    cars.where(:shuttle => true).first
  end

end
