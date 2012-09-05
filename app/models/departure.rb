class Departure < ActiveRecord::Base
  attr_accessible :time, :traveler_name
  belongs_to :car
  after_create :place_in_car

  def place_in_car
    Car.all.detect { |c| c.departure_works_with?(time)}.departures << self
  end
end
