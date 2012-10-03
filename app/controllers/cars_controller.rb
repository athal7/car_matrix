class CarsController < ApplicationController
  # GET /cars
  # GET /cars.json
  def index
    @cars = Car.all
  end

  def show
    @car = Car.find(params[:id])
  end

  def new
    @car = Car.new
  end

  def edit
    @car = Car.find(params[:id])
  end

  def create
    @car = Car.new(params[:car])

    if @car.save
      redirect_to @car, notice: 'Car was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @car = Car.find(params[:id])

    if @car.update_attributes(params[:car])
      redirect_to @car, notice: 'Car was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
  end

  def reorganize
    Car.reorganize
    redirect_to root_url, notice: 'Car Matrix was successfully reorganized!'
  end

  def car_matrix
    @flight_dates = Car.displayed_flight_dates
  end
end
