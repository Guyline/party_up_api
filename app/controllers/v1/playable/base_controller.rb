class V1::Playable::BaseController < V1::ApplicationController
  before_action :set_playable

  protected

  def playable
    @playable = Playable.find(params[:playable_id])
  end
  alias set_playable playable
end
