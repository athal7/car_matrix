class FlightsController < ApplicationController

  def index
    @flights = Flight.new_enough_flights
  end

  def show
    @flight = Flight.find(params[:id])
  end

  def new
    @flight = Flight.new
    @new = true
  end

  def edit
    @flight = Flight.find(params[:id])
  end

  def create
    date_params = params[:flight].select{|k,v| k.match(/flight_time/) }
    original_flight_time = DateTime.new(date_params["flight_time(1i)"].to_i, 
                            date_params["flight_time(2i)"].to_i,
                            date_params["flight_time(3i)"].to_i,
                            date_params["flight_time(4i)"].to_i,
                            date_params["flight_time(5i)"].to_i,
                            0,
                            "-0500")
    new_flights = []
    num_weeks = params[:repeating].to_i > 0 ? params[:repeating].to_i : 1
    num_weeks.times do |i|
      flight_time = original_flight_time + i.weeks
      new_flights << Flight.new(
        :airline => params[:flight][:airline],
        :flight_number => params[:flight][:flight_number],
        :traveler_name => params[:flight][:traveler_name],
        :flight_time => flight_time
      )
    end

    if new_flights.all?(&:valid?)
      new_flights.each(&:save)
      Car.reorganize
      redirect_to root_url, notice: 'Flight was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @flight = Flight.find(params[:id])

    if @flight.update_attributes(params[:flight])
      Car.reorganize
      redirect_to root_url, notice: 'Flight was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @flight = Flight.find(params[:id])
    @flight.destroy

    redirect_to flights_url
  end
end
