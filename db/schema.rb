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

ActiveRecord::Schema[8.1].define(version: 2025_11_05_000611) do
  create_table "copies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "asking_currency", limit: 3
    t.integer "asking_price_cents"
    t.column "condition", "enum('unknown','new','excellent','good','fair','poor')", default: "unknown", null: false
    t.datetime "created_at", null: false
    t.bigint "holder_id"
    t.boolean "is_borrowable", default: false
    t.boolean "is_playable", default: false
    t.boolean "is_purchaseable", default: false
    t.boolean "is_tradeable", default: false
    t.bigint "item_id"
    t.bigint "location_id"
    t.string "public_id"
    t.datetime "updated_at", null: false
    t.bigint "version_id"
    t.index ["created_at", "updated_at"], name: "index_copies_on_created_at_and_updated_at"
    t.index ["holder_id"], name: "index_copies_on_holder_id"
    t.index ["item_id"], name: "index_copies_on_item_id"
    t.index ["location_id"], name: "index_copies_on_location_id"
    t.index ["public_id"], name: "index_copies_on_public_id", unique: true
    t.index ["updated_at"], name: "index_copies_on_updated_at"
    t.index ["version_id"], name: "index_copies_on_version_id"
  end

  create_table "expansions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "updated_at"], name: "index_expansions_on_created_at_and_updated_at"
    t.index ["updated_at"], name: "index_expansions_on_updated_at"
  end

  create_table "games", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at", "updated_at"], name: "index_games_on_created_at_and_updated_at"
    t.index ["updated_at"], name: "index_games_on_updated_at"
  end

  create_table "identities", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.text "refresh_token"
    t.text "secret"
    t.text "token"
    t.datetime "token_expires_at"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["email"], name: "index_identities_on_email"
    t.index ["provider"], name: "index_identities_on_provider"
    t.index ["uid", "provider"], name: "index_identities_on_uid_and_provider", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "item_expansions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "expansion_id"
    t.bigint "item_id"
    t.datetime "updated_at", null: false
    t.index ["created_at", "updated_at"], name: "index_item_expansions_on_created_at_and_updated_at"
    t.index ["expansion_id"], name: "index_item_expansions_on_expansion_id"
    t.index ["item_id"], name: "index_item_expansions_on_item_id"
    t.index ["updated_at"], name: "index_item_expansions_on_updated_at"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "bgg_id"
    t.string "bgg_image_url"
    t.string "bgg_thumbnail_url"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "playable_id"
    t.string "playable_type"
    t.string "public_id"
    t.datetime "updated_at", null: false
    t.index ["bgg_id"], name: "index_items_on_bgg_id", unique: true
    t.index ["created_at", "updated_at"], name: "index_items_on_created_at_and_updated_at"
    t.index ["name"], name: "index_items_on_name"
    t.index ["playable_type", "playable_id"], name: "index_items_on_playable_type_and_playable_id", unique: true
    t.index ["public_id"], name: "index_items_on_public_id", unique: true
    t.index ["updated_at"], name: "index_items_on_updated_at"
  end

  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "google_place_id"
    t.string "number"
    t.string "postal_code"
    t.string "public_id"
    t.string "state"
    t.string "street"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["google_place_id"], name: "index_locations_on_google_place_id"
    t.index ["public_id"], name: "index_locations_on_public_id", unique: true
  end

  create_table "oauth_access_grants", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.bigint "resource_owner_id"
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.string "token", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.integer "expires_in"
    t.string "previous_refresh_token", default: "", null: false
    t.string "refresh_token"
    t.bigint "resource_owner_id"
    t.datetime "revoked_at"
    t.string "scopes"
    t.text "token", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :hash
  end

  create_table "oauth_applications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.string "secret", null: false
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "ownerships", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "copy_id"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.bigint "owner_id"
    t.string "public_id"
    t.datetime "updated_at", null: false
    t.index ["copy_id"], name: "index_ownerships_on_copy_id"
    t.index ["created_at", "updated_at"], name: "index_ownerships_on_created_at_and_updated_at"
    t.index ["discarded_at"], name: "index_ownerships_on_discarded_at"
    t.index ["owner_id", "copy_id"], name: "index_ownerships_on_owner_id_and_copy_id", unique: true
    t.index ["owner_id"], name: "index_ownerships_on_owner_id"
    t.index ["public_id"], name: "index_ownerships_on_public_id", unique: true
    t.index ["updated_at"], name: "index_ownerships_on_updated_at"
  end

  create_table "user_locations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.bigint "location_id"
    t.string "public_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["created_at", "updated_at"], name: "index_user_locations_on_created_at_and_updated_at"
    t.index ["discarded_at"], name: "index_user_locations_on_discarded_at"
    t.index ["location_id"], name: "index_user_locations_on_location_id"
    t.index ["public_id"], name: "index_user_locations_on_public_id", unique: true
    t.index ["updated_at"], name: "index_user_locations_on_updated_at"
    t.index ["user_id", "location_id"], name: "index_user_locations_on_user_id_and_location_id", unique: true
    t.index ["user_id"], name: "index_user_locations_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "bgg_username"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password"
    t.string "first_name"
    t.string "last_name"
    t.string "public_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "bgg_id"
    t.datetime "created_at", null: false
    t.bigint "item_id"
    t.string "name"
    t.string "public_id"
    t.integer "publication_year", limit: 2
    t.datetime "updated_at", null: false
    t.index ["bgg_id"], name: "index_versions_on_bgg_id", unique: true
    t.index ["created_at", "updated_at"], name: "index_versions_on_created_at_and_updated_at"
    t.index ["item_id"], name: "index_versions_on_item_id"
    t.index ["name"], name: "index_versions_on_name"
    t.index ["public_id"], name: "index_versions_on_public_id", unique: true
    t.index ["updated_at"], name: "index_versions_on_updated_at"
  end

  add_foreign_key "copies", "items"
  add_foreign_key "copies", "locations"
  add_foreign_key "copies", "users", column: "holder_id"
  add_foreign_key "copies", "versions"
  add_foreign_key "identities", "users"
  add_foreign_key "item_expansions", "expansions"
  add_foreign_key "item_expansions", "items"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "ownerships", "copies"
  add_foreign_key "ownerships", "users", column: "owner_id"
  add_foreign_key "user_locations", "locations"
  add_foreign_key "user_locations", "users"
  add_foreign_key "versions", "items"
end
