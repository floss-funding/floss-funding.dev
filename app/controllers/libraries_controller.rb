class LibrariesController < ApplicationController
  def index
    @sort = params[:sort].presence || "new"
    @q = params[:q].to_s
    @ecosystems = Array(params[:ecosystems]).compact_blank

    scope = Library.search(@q)
    scope = scope.where(ecosystem: @ecosystems) if @ecosystems.present?
    @libraries = scope.sort_by_param(@sort).includes(:activation_keys)

    @all_ecosystems = Ecosystem.list
  end

  def show
    @library = Library.find(params[:id])
    @activation_keys = @library.activation_keys.where(retired: false).order(:namespace, :key)
  end
end
