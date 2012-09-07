class Flight < ActiveRecord::Base
  attr_accessible :airline, :arrival, :car_id, :flight_number, :flight_time, :traveler_name
  belongs_to :car
end
