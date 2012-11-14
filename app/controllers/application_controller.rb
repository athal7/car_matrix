class ApplicationController < ActionController::Base
  before_filter :set_project

  protect_from_forgery

  private

  def set_project
    project_id = params[:project_id] || params[:id]
    @project = Project.find(project_id) if project_id
  end
end
