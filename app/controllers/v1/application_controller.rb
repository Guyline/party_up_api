class V1::ApplicationController < ApplicationController
  before_action :skip_session
  # before_action :doorkeeper_authorize!
  before_action :set_pagination_params,
    only: [:index]

  after_action :set_count_header,
    only: [:index]

  def index
    raise NotImplementedError
  end

  protected

  def set_pagination_params
    @page = params[:page] || 1
    @per_page = params[:per_page] || 20
    @sort = params.fetch(:sort, :created_at)
    @order = params.fetch(:order, :asc)
  end

  def set_count_header
    response.headers["X-Total-Count"] = @total_count || nil
  end

  private

  def skip_session
    request.session_options[:skip] = true
  end

  def current_user
    @current_user ||= User.where(email: "guyline82@gmail.com").first
    # @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end
end
