class ProjectsController < ApplicationController
  def index
    @sort = params[:sort].presence || "new"
    @q = params[:q].to_s
    @ecosystems = Array(params[:ecosystems]).compact_blank

    scope = Project.search(@q)
    scope = scope.where(ecosystem: @ecosystems) if @ecosystems.present?
    @projects = scope.sort_by_param(@sort).includes(:activation_keys)

    @all_ecosystems = Ecosystem.list
  end

  def show
    @project = Project.find(params[:id])
    @activation_keys = @project.activation_keys.order(:namespace, :key)
  end
end
