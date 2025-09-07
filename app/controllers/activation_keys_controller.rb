class ActivationKeysController < ApplicationController
  before_action :authenticate_account!
  before_action :set_activation_key, only: [:show, :edit, :update]

  def index
    @sort = params[:sort].presence || "new"
    @q = params[:q].to_s
    @ecosystems = Array(params[:ecosystems]).compact_blank

    scope = ActivationKey.active.search(@q)
    scope = scope.where(ecosystem: @ecosystems) if @ecosystems.present?
    @activation_keys = scope.sort_by_param(@sort)

    @all_ecosystems = Ecosystem.list
  end

  def show
    @namespace_activation_keys = ActivationKey.active.where(namespace: @activation_key.namespace).order(:key)
  end

  def new
    @activation_key = ActivationKey.new
  end

  def create
    @activation_key = ActivationKey.new(activation_key_params)
    if @activation_key.save
      redirect_to(activation_keys_path, notice: "Activation key created")
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def edit
  end

  def update
    if @activation_key.update(activation_key_update_params)
      redirect_to(activation_key_path(@activation_key), notice: "Activation key updated")
    else
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def set_activation_key
    @activation_key = ActivationKey.find(params[:id])
  end

  def activation_key_params
    # Creation params: allow all fields necessary to create
    params.require(:activation_key).permit(:library_name, :namespace, :key, :ecosystem, :featured, :free_for_open_source, :project_name, :project_url, :retired)
  end

  def activation_key_update_params
    # Update params: allow only the fields specified in the requirement
    params.require(:activation_key).permit(:project_url, :library_name, :project_name, :featured, :free_for_open_source, :retired)
  end
end
