class Flight < ActiveRecord::Base
  attr_accessible :airline, :car_id, :flight_number, :flight_time, :traveler_name, :project_id
  belongs_to :car
  belongs_to :project

  def arrival?
    flight_time.monday?
  end

  def eligible_for_shuttle?
    arrival? && ((flight_time.hour == 15 && flight_time.min >= 30) || flight_time.hour > 15)
  end
end
