class MonetizeAskingPriceOnCopies < ActiveRecord::Migration[7.1]
  def change
    remove_column :copies,
      :asking_price,
      :decimal,
      null: true,
      default: nil,
      precision: 7,
      scale: 2,
      after: :is_purchaseable
    add_column :copies,
      :asking_price_cents,
      :integer,
      null: true,
      default: nil,
      after: :is_purchaseable
  end
end
