module V1::Concerns::HandlesCopies
  extend ActiveSupport::Concern

  included do
    protected

    def copy_params
      params.expect(
        copy: %i[
          asking_currency
          asking_price
          condition
          holder_id
          is_borrowable
          is_playable
          is_purchaseable
          is_tradeable
          version_id
        ]
      )
    end

    def valid_includes
      {
        "holder" => :holder,
        "item" => :item,
        "location" => :location,
        "ownerships" => :ownerships,
        "ownerships.owner" => :owners,
        "version" => :version
      }
    end
  end
end
