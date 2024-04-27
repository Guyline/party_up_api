class V1::Copy::BaseController < V1::ApplicationController
  before_action :set_copy

  protected

  def copy
    @copy = Copy.find(params[:copy_id])
  end
  alias set_copy copy
end
