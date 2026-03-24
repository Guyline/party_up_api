module V1::Concerns::HandlesVersions
  extend ActiveSupport::Concern

  included do
    protected

    def valid_includes
      {
        "item" => :item
      }
    end
  end
end
