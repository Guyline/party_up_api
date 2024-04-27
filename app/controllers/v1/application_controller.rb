class V1::ApplicationController < ActionController::API
  before_action :set_pagination_params, only: [:index]

  protected

  def set_pagination_params
    @page = params[:page]
    @per_page = params[:per_page]
    @sort = params.fetch(:sort, :created_at)
    @order = params.fetch(:order, :asc)
  end
end
