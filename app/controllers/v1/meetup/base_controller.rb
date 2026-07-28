class V1::Meetup::BaseController < V1::ApplicationController
  protected

  def meetup
    @meetup = Meetup.find_by!(public_id: params[:meetup_id])
  end
end
