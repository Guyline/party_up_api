class Playable < ApplicationRecord
  validates :name, presence: true
  validates :bgg_id, uniqueness: true, allow_nil: true

  has_many :copies, inverse_of: :playable
  has_many :holders, -> { distinct }, through: :copies, source: :holder
  has_many :owners, -> { distinct }, through: :ownerships, source: :owner
  has_many :ownerships, through: :copies, source: :ownerships
  has_many :versions, inverse_of: :playable

  def resynchronize
    raise "Unable to resychronize record without :bgg_id specified" unless bgg_id

    ResynchronizePlayablesJob.perform_async(id)
  end

  def self.resynchronize(untyped_only: true)
    query_base = untyped_only ? where(type: nil) : self
    query_base.where.not(bgg_id: nil)

    processed_playable_ids = []
    batch_size = 20
    loop do
      playable_ids = query_base.where.not(id: processed_playable_ids).limit(batch_size).pluck(:id)
      break if playable_ids.empty?

      ResynchronizePlayablesJob.perform_async(playable_ids)

      processed_playable_ids += playable_ids
    end
  end
end
