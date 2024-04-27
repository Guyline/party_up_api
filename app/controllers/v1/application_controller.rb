class V1::ApplicationController < ActionController::API
  before_action :set_pagination_params, only: [:index]

  protected

  def set_pagination_params
    @page = params[:page]
    @per_page = params[:per_page]
  end
end
