# Defines process for resyncronizing collection of Items from array of IDs
class ResynchronizeItemsJob
  include Sidekiq::Job

  def perform(item_ids)
    item_ids = [item_ids] unless item_ids.is_a?(Array)
    bgg_ids = Item.where(id: item_ids).where.not(bgg_id: nil).pluck(:bgg_id)
    BoardGameGeek::Thing.with_ids(bgg_ids).find_each do |bgg_thing|
      Rails.logger.info "Processing #{bgg_thing.name} (#{bgg_thing.class} ##{bgg_thing.id})"
      Item.from_bgg_thing(bgg_thing, with_expansions: true, with_expandables: true)
    rescue => e
      Rails.logger.error e.message
      next
    end
  end
end
