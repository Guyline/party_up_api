class V1::MeetupsController < V1::ApplicationController
  def create
    @meetup = index_query.create!(meetup_params)

    render "v1/meetups/show"
  end

  
end
