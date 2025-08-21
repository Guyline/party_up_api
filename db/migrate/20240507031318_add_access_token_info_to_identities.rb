class AddAccessTokenInfoToIdentities < ActiveRecord::Migration[7.1]
  def change
    add_column :identities,
      :token,
      :text,
      after: :uid,
      null: true,
      default: nil
    add_column :identities,
      :secret,
      :text,
      after: :token,
      null: true,
      default: nil
    add_column :identities,
      :refresh_token,
      :text,
      after: :secret,
      null: true,
      default: nil
    add_column :identities,
      :token_expires_at,
      :datetime,
      after: :refresh_token,
      null: true,
      default: nil

    add_column :identities,
      :first_name,
      :string,
      after: :token_expires_at,
      null: true,
      default: nil
    add_column :identities,
      :last_name,
      :string,
      after: :first_name,
      null: true,
      default: nil
  end
end
