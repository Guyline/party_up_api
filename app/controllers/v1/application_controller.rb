class V1::ApplicationController < ApplicationController
  before_action :skip_session
  before_action :doorkeeper_authorize!
  before_action :set_pagination_params,
    only: [:index]

  def index
    raise "Method not defined"
  end

  private

  def skip_session
    request.session_options[:skip] = true
  end

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  def set_pagination_params
    @page = params[:page]
    @per_page = params[:per_page]
    @sort = params.fetch(:sort, :created_at)
    @order = params.fetch(:order, :asc)
  end
end
