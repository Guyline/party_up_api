# Defines process for resyncronizing collection of Playables from array of IDs
class ResynchronizePlayablesJob
  include Sidekiq::Job

  def perform(playable_ids)
    playable_ids = [playable_ids] unless playable_ids.is_a?(Array)
    bgg_ids = Playable.where(id: playable_ids).where.not(bgg_id: nil).pluck(:bgg_id)
    BoardGameGeek::Playable.with_ids(bgg_ids).find_each do |bgg_playable|
      p "Processing #{bgg_playable.name} (#{bgg_playable.class} ##{bgg_playable.id})"
      find_or_create_playable(bgg_playable)
    rescue => e
      p e.message
      next
    end
  end

  protected

  def find_or_create_playable(bgg_playable)
    case bgg_playable
    when BoardGameGeek::Game
      bgg_playable.find_or_create_game(find_or_create_expansions: true)
    when BoardGameGeek::Expansion
      bgg_playable.find_or_create_expansion(find_or_create_expandables: true, find_or_create_expansions: true)
    end
  end
end
