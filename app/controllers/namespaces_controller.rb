class NamespacesController < ApplicationController
  def index
    @sort = params[:sort].presence || "new"
    @q = params[:q].to_s
    @ecosystems = Array(params[:ecosystems]).compact_blank

    scope = Namespace.search(@q)
    scope = scope.where(ecosystem: @ecosystems) if @ecosystems.present?
    @namespaces = scope.sort_by_param(@sort).includes(:activation_keys)

    @all_ecosystems = Ecosystem.list
  end

  def show
    @namespace = Namespace.find(params[:id])
    @activation_keys = @namespace.activation_keys.where(retired: false).order(:key)
  end
end
