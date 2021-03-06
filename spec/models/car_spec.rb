require 'spec_helper'

describe Car do
  describe ".displayed_flight_dates" do
    it "returns a sorted, uniqed list of all of the displayed flight dates for all cars" do
      car = Car.create
      car2 = Car.create
      flight = Flight.new({:flight_time => DateTime.now - 2.days})
      flight_2 = Flight.new({:flight_time => DateTime.now})
      flight_3 = Flight.new({:flight_time => DateTime.now})
      flight_4 = Flight.new({:flight_time => DateTime.now + 4.days})
      flight_5 = Flight.new({:flight_time => DateTime.now + 6.days})
      car.flights << flight
      car.flights << flight_2
      car2.flights << flight_3
      car2.flights << flight_4
      car2.flights << flight_5
      Car.displayed_flight_dates.should == [Date.today, Date.today + 4.days]
    end
  end
  describe "#displayed_flight_dates" do
    it "returns the dates of the car's flights within a specified range" do
      car = Car.new
      flight = Flight.new({:flight_time => DateTime.now - 2.days})
      flight_2 = Flight.new({:flight_time => DateTime.now})
      flight_3 = Flight.new({:flight_time => DateTime.now + 4.days})
      flight_4 = Flight.new({:flight_time => DateTime.now + 6.days})
      car.flights << flight
      car.flights << flight_2
      car.flights << flight_3
      car.flights << flight_4

      car.displayed_flight_dates.should == [Date.today, Date.today + 4.days]

    end
  end

  describe "#flights_for_date" do
    it "returns the car's flights for a specific date" do
      car = Car.new
      flight = Flight.new({:flight_time => DateTime.now})
      flight_2 = Flight.new({:flight_time => DateTime.now})
      flight_3 = Flight.new({:flight_time => DateTime.now + 1.day})
      car.flights << flight
      car.flights << flight_2
      car.flights << flight_3

      car.flights_for_date(Date.today).should == [flight, flight_2]
    end
  end

  describe "#works_with?" do
    context "when the car is a shuttle" do
      let(:car) { Car.new({:shuttle => true, :num_seats => 5}) }
      let(:flight) { Flight.new({:flight_time => DateTime.now}) }
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
      let(:car) { Car.new }
      let(:flight) { Flight.new({:flight_time => DateTime.now}) }
      context "when the car is full" do
        it "is false" do
          car.update_attribute(:num_seats, 1)
          flight_2 = Flight.new({:flight_time => DateTime.now})
          car.flights << flight_2
          car.works_with?(flight).should be false
        end
      end
      context "when the car is not full" do
        context "when all flights for that day are within the proper time period" do
          it "is true" do
            car.update_attribute(:num_seats, 2)
            flight_2 = Flight.new({:flight_time => DateTime.now + 28.minutes})
            car.flights << flight_2
            car.works_with?(flight).should be true
          end
        end
        context "when there is a flight on that day that is too far apart" do
          it "is false" do
            car.update_attribute(:num_seats, 2)
            flight_2 = Flight.new({:flight_time => DateTime.now + 35.minutes})
            car.flights << flight_2
            car.works_with?(flight).should be false
          end
        end
      end
    end
  end

  describe "#reorganize" do
    it "calls the singleton method" do
      car = Car.new
      Car.should_receive(:reorganize).once
      car.reorganize
    end

  end
end
