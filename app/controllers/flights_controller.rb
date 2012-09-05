class FlightsController < ApplicationController

  def index
    @flights = Flight.all
  end

  def show
    @flight = Flight.find(params[:id])
  end

  def new
    @flight = Flight.new
  end

  def edit
    @flight = Flight.find(params[:id])
  end

  def create
    @flight = Flight.new(params[:flight])

    if @flight.save
      redirect_to root_url, notice: 'Flight was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @flight = Flight.find(params[:id])

    if @flight.update_attributes(params[:flight])
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
