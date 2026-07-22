class AddAttendeeLimitsToMeetups < ActiveRecord::Migration[8.1]
  def change
    add_column :meetups,
      :min_attendees_count,
      :integer,
      unsigned: true,
      null: true,
      default: nil,
      after: :exclusivity
    add_column :meetups,
      :max_attendees_count,
      :integer,
      unsigned: true,
      null: true,
      default: nil,
      after: :min_attendees_count
  end
end
