class Play < ApplicationRecord
  include HasPublicId
  include StripsAttributes

  self.public_id_prefix = "ply"
end
