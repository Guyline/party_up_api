module V1::Concerns::HandlesMeetups
  extend ActiveSupport::Concern

  included do
    protected

    def meetup_params
      params.require(:data)
        .require(:attributes)
        .permit(
          :description,
          :ends_at,
          :exclusivity,
          :is_public,
          :status,
          :max_attendees_count,
          :min_attendees_count,
          :starts_at
        )
    end

    def valid_includes
      {
        "attendees" => :attendees,
        "creator" => :creator,
        "invites" => :invites,
        "location" => :location,
        "proposals" => :proposals
      }
    end

    def serializer
      MeetupSerializer
    end
  end
end
