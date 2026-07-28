class V1::MeetupsController < V1::ApplicationController
  include V1::Concerns::HandlesMeetups

  def create
    @meetup = Meetup.create!(meetup_params.merge(creator: current_user))
    render json: MeetupSerializer.new(@meetup).serializable_hash
  end

  protected

  def index_query
    Meetup
  end
end
