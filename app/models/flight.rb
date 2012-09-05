class Flight < ActiveRecord::Base
  attr_accessible :airline, :arrival, :car_id, :flight_number, :flight_time, :traveler_name
  belongs_to :car
  after_create :place_in_car

  def place_in_car
    shuttle = Car.where(:shuttle => true).first
    if shuttle.works_with?(self)
      shuttle.flights << self
    else
      Car.all.detect{|c| c.works_with?(self)}.flights << self
    end
  end
end
