class NamespacesController < ApplicationController
  def index
    @q = params[:q].to_s
    sort = params[:sort].to_s
    order = case sort
    when "name_desc" then {name: :desc}
    else {name: :asc}
    end
    @namespaces = Namespace.search(@q).order(order).includes(:activation_keys)
  end

  def show
    @namespace = Namespace.find(params[:id])
    @activation_keys = @namespace.activation_keys.where(retired: false).order(:key)
  end
end
