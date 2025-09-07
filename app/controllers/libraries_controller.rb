class LibrariesController < ApplicationController
  def index
    @q = params[:q].to_s
    sort = params[:sort].to_s
    order = case sort
    when "name_desc" then {name: :desc}
    else {name: :asc}
    end
    @libraries = Library.search(@q).order(order).includes(:activation_keys)
  end

  def show
    @library = Library.find(params[:id])
    @activation_keys = @library.activation_keys.where(retired: false).order(:namespace, :key)
  end
end
