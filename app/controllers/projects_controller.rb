class ProjectsController < ApplicationController
  def index
    @q = params[:q].to_s
    sort = params[:sort].to_s
    order = case sort
    when "name_desc" then {name: :desc}
    else {name: :asc}
    end
    @projects = Project.search(@q).order(order).includes(:activation_keys)
  end

  def show
    @project = Project.find(params[:id])
    @activation_keys = @project.activation_keys.order(:namespace, :key)
  end
end
