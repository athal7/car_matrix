class CarsController < ApplicationController
  def index
    @cars = @project.cars
  end

  def new
    @car = Car.new
  end

  def edit
    @car = Car.find(params[:id])
  end

  def create
    @car = Car.new(params[:car])
    @car.project_id = params[:project_id]

    if @car.save
      @project.reorganize
      redirect_to project_cars_path(@project), notice: 'Car was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @car = Car.find(params[:id])

    if @car.update_attributes(params[:car])
      @project.reorganize
      redirect_to project_cars_path(@project), notice: 'Car was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to project_cars_path(@project), notice: "Car was successfully deleted."
  end
end
