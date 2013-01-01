module CarsHelper

  def flight_time_text(date)
    arrival_date?(date) ? "Arrival Time" : "Departure Time"
  end

  def main_travel_date?(cars, date)
    num_flights = cars.map{|car| car.flights_for_date(date).size}.sum
    num_flights >= 3
  end

  def arrival_date?(date)
    date.to_date.monday? || date.to_date.sunday? || date.to_date.tuesday? || date.to_date.wednesday?
  end
end
