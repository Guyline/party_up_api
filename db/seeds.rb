# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

application = Oauth::Application.where(name: "party_up_ui").first_or_create
Rails.logger.debug "Application:"
Rails.logger.debug { "  id: #{application.id}" }
Rails.logger.debug { "  client_id: #{application.uid}" }
Rails.logger.debug { "  clent_secret: #{application.plaintext_secret}" }

# The following block was used when transitioning from STI to delgated types
# This involved finding records with a `type` specified without an associated
#   record in 'games' or 'expansions' and creating the relevant record based
#   on the set `type`
#
# item_map = {
#   "Playable::Game" => Game,
#   "Playable::Expansion" => Expansion
# }
#
# Item.where(playable_id: nil, playable_type: nil).find_each do |item|
#   klass = item_map[item.type]
#   next if klass.nil?
#
#   playable = klass.create!
#   item.playable = playable
#   item.save!
# end

user_attribute_sets = [
  {
    username: "Guyline",
    bgg_username: "Guyline",
    email_address: "guyline82@gmail.com",
    password: "password"
  }
]

user_attribute_sets.each do |user_attributes|
  user = User.find_or_create_by!(email: user_attributes[:email_address]) do |u|
    Rails.logger.info "Creating User with email #{user_attributes[:email_address]}..."
    u.username = user_attributes[:username]
    u.bgg_username = user_attributes[:bgg_username]
    u.password = user_attributes[:password]
  end

  counts = {
    expansions: 0,
    games: 0,
    items: 0,
    unknown: 0
  }
  BoardGameGeek::Thing.for_user(user).find_each do |bgg_thing|
    unless bgg_thing.is_a?(BoardGameGeek::Thing)
      raise "Expected instance of BoardGameGeek::Thing, #{bgg_thing.class.name} detected!"
    end

    item = Item.from_bgg_thing(bgg_thing)
    copy = user.owned_copies.find_or_create_by!(item:)

    status = " - Processing '#{item.name}..."
    status += copy.previously_new_record? ? "created!" : "found!"
    Rails.logger.info status

    counts[:items] += 1
    case item.class
    when Game then counts[:games] += 1
    when Expansion then counts[:expansions] += 1
    else counts[:unknown] += 1
    end
  end

  Rails.logger.info "Found #{counts[:games]} games " \
    "and #{counts[:expansions]} expansions " \
    "(#{counts[:unknown]} unknown, #{counts[:items]} total) " \
    "for user ##{user.id} (#{user.bgg_username})"
end

# Item.resynchronize
