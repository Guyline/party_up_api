module V1::Concerns::HandlesItems
  extend ActiveSupport::Concern

  included do
    protected

    def valid_includes
      {
        "expandables" => :expandables,
        "expansions" => :expansions
      }
    end
  end
end
