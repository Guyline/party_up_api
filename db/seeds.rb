# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

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
    p "Creating User with email #{user_attributes[:email_address]}..."
    u.username = user_attributes[:username]
    u.bgg_username = user_attributes[:bgg_username]
    u.password = user_attributes[:password]
  end

  counts = {
    expansions: 0,
    games: 0,
    playables: 0
  }
  BoardGameGeek::Playable.for_user(user).find_each do |bgg_playable|
    unless bgg_playable.is_a?(BoardGameGeek::Playable)
      raise "Expected instance of BoardGameGeek::Playable, #{bgg_playable.class.name} detected!"
    end

    playable = bgg_playable.find_or_create_playable

    counts[:playables] += 1
    case playable.class
    when Game then counts[:games] += 1
    when Expansion then counts[:expansions] += 1
    end
  end

  p "Found #{counts[:games]} games " \
    "and #{counts[:expansions]} expansions " \
    "(#{counts[:playables]} total) " \
    "for user ##{user.id} (#{user.bgg_username})"
end

Playable.resynchronize
