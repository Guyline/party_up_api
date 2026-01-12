# frozen_string_literal: true

class ConvertIdAndAddPublicId < ActiveRecord::Migration[8.1]
  def change
    change_table :copies do |t|
      t.remove_references :holder,
        type: :uuid,
        foreign_key: {
          to_table: :users
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :item,
        type: :uuid,
        foreign_key: {
          to_table: :items
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :version,
        type: :uuid,
        foreign_key: true,
        null: true,
        default: nil,
        after: :id
      t.remove :location_id,
        type: :uuid,
        null: true,
        default: nil,
        after: :id
    end

    change_table :identities do |t|
      t.remove_references :user,
        type: :uuid,
        foreign_key: true
    end

    change_table :item_expansions do |t|
      t.remove_references :item,
        type: :uuid,
        foreign_key: {
          to_table: :items
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :expansion,
        type: :uuid,
        foreign_key: {
          to_table: :expansions
        },
        null: true,
        default: nil,
        after: :id
    end

    change_table :oauth_access_grants do |t|
      t.remove_references :resource_owner,
        type: :uuid,
        foreign_key: {
          to_table: :users
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :application,
        type: :uuid,
        foreign_key: {
          to_table: :oauth_applications
        },
        null: true,
        default: nil,
        after: :id
    end

    change_table :oauth_access_tokens do |t|
      t.remove_references :resource_owner,
        type: :uuid,
        foreign_key: {
          to_table: :users
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :application,
        type: :uuid,
        foreign_key: {
          to_table: :oauth_applications
        },
        null: true,
        default: nil,
        after: :id
    end

    change_table :ownerships do |t|
      t.remove_index %i[copy_id owner_id],
        unique: true
      t.remove_references :copy,
        type: :uuid,
        foreign_key: {
          to_table: :copies
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :owner,
        type: :uuid,
        foreign_key: {
          to_table: :users
        },
        null: true,
        default: nil,
        after: :id
    end

    change_table :user_locations do |t|
      t.remove_index %i[user_id location_id],
        unique: true
      t.remove_references :user,
        type: :uuid,
        foreign_key: {
          to_table: :users
        },
        null: true,
        default: nil,
        after: :id
      t.remove_references :location,
        type: :uuid,
        foreign_key: {
          to_table: :locations
        },
        null: true,
        default: nil,
        after: :id
    end

    change_table :versions do |t|
      t.remove_references :item,
        type: :uuid,
        foreign_key: {
          to_table: :items
        },
        null: true,
        default: nil,
        after: :id
    end

    ##########
    # copies #
    ##########

    change_ids(:copies)
    add_reference :ownerships,
      :copy,
      foreign_key: {
        to_table: :copies
      },
      null: true,
      default: nil,
      after: :id

    ##############
    # expansions #
    ##############

    change_ids(:expansions, false)
    add_reference :item_expansions,
      :expansion,
      foreign_key: {
        to_table: :expansions
      },
      null: true,
      default: nil,
      after: :id

    #########
    # games #
    #########

    change_ids(:games, false)

    ##############
    # identities #
    ##############

    change_ids(:identities, false)

    #########
    # items #
    #########

    change_ids(:items)
    remove_index :items,
      %i[playable_type playable_id],
      unique: true
    remove_column :items,
      :playable_id,
      :uuid,
      null: true,
      default: nil,
      after: :public_id
    add_column :items,
      :playable_id,
      :bigint,
      null: true,
      default: nil,
      after: :public_id
    add_index :items,
      %i[playable_type playable_id],
      unique: true
    add_reference :copies,
      :item,
      foreign_key: {
        to_table: :items
      },
      null: true,
      default: nil,
      after: :public_id
    add_reference :item_expansions,
      :item,
      foreign_key: {
        to_table: :items
      },
      null: true,
      default: nil,
      after: :id
    add_reference :versions,
      :item,
      foreign_key: {
        to_table: :items
      },
      null: true,
      default: nil,
      after: :id

    #############
    # locations #
    #############

    change_ids(:locations)
    add_reference :copies,
      :location,
      foreign_key: {
        to_table: :locations
      },
      null: true,
      default: nil,
      after: :item_id
    add_reference :user_locations,
      :location,
      foreign_key: {
        to_table: :locations
      },
      null: true,
      default: nil,
      after: :id

    #######################
    # oauth_access_grants #
    #######################

    change_ids(:oauth_access_grants, false)

    #######################
    # oauth_access_tokens #
    #######################

    change_ids(:oauth_access_tokens, false)

    ######################
    # oauth_applications #
    ######################

    change_ids(:oauth_applications, false)
    add_reference :oauth_access_grants,
      :application,
      foreign_key: {
        to_table: :oauth_applications
      },
      null: true,
      default: nil,
      after: :id
    add_reference :oauth_access_tokens,
      :application,
      foreign_key: {
        to_table: :oauth_applications
      },
      null: true,
      default: nil,
      after: :id

    ##############
    # ownerships #
    ##############

    change_ids(:ownerships)

    ##################
    # user_locations #
    ##################

    change_ids(:user_locations)

    #########
    # users #
    #########

    change_ids(:users)
    add_reference :copies,
      :holder,
      foreign_key: {
        to_table: :users
      },
      null: true,
      default: nil,
      after: :public_id
    add_reference :identities,
      :user,
      foreign_key: {
        to_table: :users
      },
      null: true,
      default: nil,
      after: :id
    add_reference :oauth_access_grants,
      :resource_owner,
      foreign_key: {
        to_table: :users
      },
      null: true,
      default: nil,
      after: :id
    add_reference :oauth_access_tokens,
      :resource_owner,
      foreign_key: {
        to_table: :users
      },
      null: true,
      default: nil,
      after: :id
    add_reference :ownerships,
      :owner,
      foreign_key: {
        to_table: :users
      },
      null: true,
      default: nil,
      after: :public_id
    add_index :ownerships,
      %i[owner_id copy_id],
      unique: true
    add_reference :user_locations,
      :user,
      foreign_key: {
        to_table: :users
      },
      null: true,
      default: nil,
      after: :public_id
    add_index :user_locations,
      %i[user_id location_id],
      unique: true

    ############
    # versions #
    ############

    change_ids(:versions)
    add_reference :copies,
      :version,
      foreign_key: {
        to_table: :versions
      },
      null: true,
      default: nil,
      after: :item_id
  end

  def change_ids(table_name, add_public_id = true)
    change_table table_name do |t|
      t.remove :id,
        type: :uuid,
        null: false,
        primary_key: true,
        first: true

      t.primary_key :id, # standard:disable Rails/DangerousColumnNames
        first: true

      if add_public_id
        t.string :public_id,
          null: true,
          default: nil,
          after: :id

        t.index :public_id,
          unique: true
      end
    end
  end
end
