# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_25_001259) do
# Could not dump table "copies" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "games" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "identities" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "ownerships" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "users" because of following StandardError
#   Unknown type 'uuid' for column 'id'

# Could not dump table "versions" because of following StandardError
#   Unknown type 'uuid' for column 'id'

  add_foreign_key "copies", "games"
  add_foreign_key "copies", "users", column: "holder_id"
  add_foreign_key "copies", "versions"
  add_foreign_key "identities", "users"
  add_foreign_key "ownerships", "copies"
  add_foreign_key "ownerships", "users", column: "owner_id"
  add_foreign_key "versions", "games"
end
