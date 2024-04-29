class V1::Owner::BaseController < V1::ApplicationController
  before_action :set_owner

  protected

  def owner
    @owner = User.find(params[:owner_id])
  end
  alias set_owner owner
end
