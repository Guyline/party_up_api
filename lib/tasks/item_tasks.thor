class ItemTasks < Thor
  namespace :item

  PROGRESSBAR_FORMAT = "%t |%B| %c/%C (%j%%)"

  desc "import FILENAME", "Import BGG collection export as items owned by a given user"
  method_options username: :string
  def import(path)
    username = options[:username] || ask("Username?")
    user = User.find_or_create_by!(username: username) do |u|
      say("Creating new user with username '#{username}'...", :green)
      u.email = ask("Email?")
      u.password = ask("Password?", echo: false)
    end
    say("Importing collection for user '#{set_color(user.public_id, :green)}'")

    say("Looking for file at #{set_color(path, :blue)}", nil, false)
    progressbar = ProgressBar.create(
      total: File.foreach(path).count - 1,
      format: PROGRESSBAR_FORMAT
    )

    counts = {
      copies_created: 0,
      errors_encountered: 0,
      expansions_created: 0,
      games_created: 0,
      items_created: 0,
      items_processed: 0,
      ownerships_created: 0
    }

    CSV.foreach(path, headers: true, converters: :all) do |row|
      # pp row.to_hash
      progressbar.increment

      bgg_id = row["objectid"]
      unless bgg_id.is_a? Numeric
        counts[:errors_encountered] += 1
        next
      end

      item = Item.find_or_create_by(bgg_id: bgg_id) do |i|
        case row["itemtype"]
        when "standalone"
          i.becomes! Game
          counts[:games_created] += 1
        when "expansion"
          i.becomes! Expansion
          counts[:expansions_created] += 1
        else
          throw :abort
        end
        i.name = row["objectname"]
      end

      unless item.is_a? Item
        counts[:errors_encountered] += 1
        next
      end
      counts[:items_processed] += 1
      counts[:items_created] += 1 if item.previously_new_record?

      next if item.ownerships.where(owner: user).exists?

      copy = Copy.create(item: item)
      unless copy.is_a? Copy
        counts[:errors_encountered] += 1
        next
      end
      counts[:copies_created] += 1

      ownership = Ownership.create(copy: copy, owner: user)
      unless ownership.is_a? Ownership
        counts[:errors_encountered] += 1
        next
      end
      counts[:ownerships_created] += 1
    end

    progressbar.finish unless progressbar.finished?
    pp counts
  end

  desc "synchronize [ITEM_ID]",
    "Resynchronize item details from BGG - presence of ITEM_ID specifies synchronization of one or all items."
  def synchronize(item_id = nil)
    if item_id.to_i.to_s == item_id
      item_id = Integer(item_id)
      say("Synchronizing item ##{set_color(item_id, :green)}...")
      query = Item.unscoped.where(id: item_id)
    else
      say("Synchronizing all items...")
      query = Item.unscoped.where.not(bgg_id: nil)
    end

    progressbar = ProgressBar.create(
      total: query.count,
      format: PROGRESSBAR_FORMAT
    )

    query.select(:id).find_each do |item|
      say(" - Processing Item ##{item.id}...")
      ResynchronizeItemsJob.perform_async(item.id)
      progressbar.increment
    end

    progressbar.finish unless progressbar.finished?
    say("Done!")
  end
end
