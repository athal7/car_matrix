class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def show
    @cars = @project.cars.includes(:flights)
    @flight_dates = @project.displayed_flight_dates
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @project.update_attributes(params[:project])
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url
  end

  def reorganize
    if @project.reorganize
      redirect_to project_path(@project), notice: 'Car Matrix was successfully reorganized!'
    else
      redirect_to project_admin_index_path(@project), notice: 'Car Matrix was not able to reorganize, please try again!'
    end
  end
end
