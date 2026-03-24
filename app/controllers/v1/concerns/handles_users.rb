module V1::Concerns::HandlesUsers
  extend ActiveSupport::Concern

  included do
    protected

    def user_params
      params.expect(
        users: [
          :first_name,
          :last_name
        ]
      )
    end

    def valid_includes
      {}
    end
  end
end
