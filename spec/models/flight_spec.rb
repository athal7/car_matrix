require 'spec_helper'

describe Flight do
  describe ".new_enough_flights" do
    it "returns flights not older than yesterday sorted by flight time ascending" do
      older_flight = Flight.create({:flight_time => DateTime.now - 2.days})
      newer_flight = Flight.create({:flight_time => DateTime.now + 2.days})
      flight = Flight.create({:flight_time => DateTime.now})
      Flight.new_enough_flights.should == [flight, newer_flight]
    end
  end

  describe "#arrival?" do
    context "the flight is on a monday" do
      it "is true" do
        flight = Flight.new({:flight_time => DateTime.parse("Oct 1 2012 10:00pm")})
        flight.arrival?.should be true
      end
    end
    context "the flight is on any other day" do
      it "is false" do
        (2..7).each do |i|
          flight = Flight.new({:flight_time => DateTime.parse("Oct #{i} 2012 10:00pm")})
          flight.arrival?.should be false
        end
      end
    end
  end

  describe "#eligible_for_shuttle?" do
    context "flight is an arrival" do
      let(:flight) { Flight.new }
      before { flight.stub(:arrival?).and_return true }
      context "flight is after 330pm" do
        it "is true" do
          flight.update_attribute(:flight_time, DateTime.parse("Oct 1 2012 3:31pm est"))
          flight.eligible_for_shuttle?.should be true
        end
      end
      context "flight is before 330pm" do
        it "is false" do
          flight.update_attribute(:flight_time, DateTime.parse("Oct 1 2012 2:29pm est"))
          flight.eligible_for_shuttle?.should be false
        end
      end
    end
    context "flight is not an arrival" do
      it "is false" do
        flight = Flight.new
        flight.stub(:arrival?).and_return false
        flight.eligible_for_shuttle?.should be false
      end
    end
  end
end
