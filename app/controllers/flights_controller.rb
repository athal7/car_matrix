class FlightsController < ApplicationController

  def index
    @flights = @project.new_enough_flights
  end

  def new
    @flight = Flight.new
  end

  def edit
    @flight = Flight.find(params[:id])
  end

  def create
    @flight = Flight.new(params[:flight])
    @flight.project_id = params[:project_id]

    if @flight.save
      @project.reorganize
      redirect_to project_flights_path(@project), notice: 'Flight was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @flight = Flight.find(params[:id])

    if @flight.update_attributes(params[:flight])
      @project.reorganize
      redirect_to project_flights_path(@project), notice: 'Flight was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @flight = Flight.find(params[:id])
    @flight.destroy

    redirect_to project_flights_path(@project)
  end
end
