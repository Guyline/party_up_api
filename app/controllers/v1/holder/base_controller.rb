class V1::Holder::BaseController < V1::ApplicationController
  before_action :set_holder

  protected

  def holder
    @holder = User.find(params[:holder_id])
  end
  alias_method :set_holder, :holder
end
