require 'spec_helper'

describe Car do
  context "#works_with?" do

    context "when the car is a shuttle" do
      let(:car) { Car.create({:shuttle => true, :num_seats => 5}) }
      let(:flight) { Flight.create({:flight_time => DateTime.now}) }
      it "is true when the flight is eligible for a shuttle" do
        flight.stub(:eligible_for_shuttle?).and_return(true)
        car.works_with?(flight).should be true
      end
      it "is false when the flight is not eligible for a shuttle" do
        flight.stub(:eligible_for_shuttle?).and_return(false)
        car.works_with?(flight).should be false
      end
    end

    context "when the car is not a shuttle" do
      let(:car) { Car.create }
      let(:flight) { Flight.create({:flight_time => DateTime.now}) }
      context "when the car is full" do
        it "is false" do
          car.update_attribute(:num_seats, 1)
          flight_2 = Flight.create({:flight_time => DateTime.now})
          car.flights << flight_2
          car.works_with?(flight).should be false
        end
      end
      context "when the car is not full" do
        context "when all flights for that day are within the proper time period" do
          it "is true" do
            car.update_attribute(:num_seats, 2)
            flight_2 = Flight.create({:flight_time => DateTime.now + 28.minutes})
            car.flights << flight_2
            car.works_with?(flight).should be true
          end
        end
        context "when there is a flight on that day that is too far apart" do
          it "is false" do
            car.update_attribute(:num_seats, 2)
            flight_2 = Flight.create({:flight_time => DateTime.now + 35.minutes})
            car.flights << flight_2
            car.works_with?(flight).should be false
          end
        end
      end
    end
  end
end
