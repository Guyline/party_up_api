module V1::Concerns::HandlesCopies
  extend ActiveSupport::Concern

  included do
    protected

    def copy_params
      params.expect(
        copy: %i[
          holder_id
          version_id
          condition
          is_purchaseable
          is_tradeable
          is_playable
          is_borrowable
          asking_price
          asking_currency
        ]
      )
    end
  end
end
