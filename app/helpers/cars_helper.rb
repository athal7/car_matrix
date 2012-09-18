module CarsHelper

  def flight_time_text(date)
    arrival_date?(date) ? "Arrival Time" : "Departure Time"
  end

  def main_travel_date?(date)
    date.to_date.monday? || date.to_date.thursday? 
  end

  def arrival_date?(date)
    date.to_date.monday? || date.to_date.sunday? || date.to_date.tuesday? 
  end
end
