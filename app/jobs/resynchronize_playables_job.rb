class ResynchronizePlayablesJob
  include Sidekiq::Job

  def perform(playable_ids)
    playable_ids = [playable_ids] unless playable_ids.is_a?(Array)
    bgg_ids = Playable.where(id: playable_ids).where.not(bgg_id: nil).pluck(:bgg_id)
    bgg_playables = BoardGameGeek::Playable.find(bgg_ids)

    bgg_playables.each_value do |bgg_playable|
      case bgg_playable
      when BoardGameGeek::Game
        begin
          bgg_playable.find_or_create_game(find_or_create_expansions: true)
        rescue ActiveRecord::RecordInvalid => e
          p "ValidationError detected for game or expansions for #{bgg_playable.name} (#{bgg_playable.class} #{bgg_playable.id})."
          puts e.message
          next
        rescue StandardError => e
          p "Unable to find/create game or expansions for #{bgg_playable.name} (#{bgg_playable.class} #{bgg_playable.id})."
          p e.message
          next
        end
      when BoardGameGeek::Expansion
        begin
          bgg_playable.find_or_create_expansion(find_or_create_expandables: true, find_or_create_expansions: true)
        rescue ActiveRecord::RecordInvalid => e
          p "ValidationError detected for expansion or games for #{bgg_playable.name} (#{bgg_playable.class} #{bgg_playable.id})."
          puts e.message
          next
        rescue StandardError => e
          p "Unable to find/create expansion or games for #{bgg_playable.name} (#{bgg_playable.class} #{bgg_playable.id})."
          p e.message
          next
        end
      else
        p "Unable to process playable of type '#{bgg_playable.class}'."
        next
      end
    end
  end
end
