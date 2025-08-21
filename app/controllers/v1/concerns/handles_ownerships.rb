module V1::Concerns::HandlesOwnerships
  extend ActiveSupport::Concern

  included do
    protected

    def ownership_params
      params.expect(ownerships: [:owner_id])
    end
  end
end
