class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create do
    self.id ||= ApplicationRecord.generate_primary_key unless type_for_attribute(:id).type == :integer
  end

  self.implicit_order_column = :created_at

  def self.api_relationships
    belongs_to_associations = reflect_on_all_associations(:belongs_to)
    belongs_to_associations.map(&:name).sort!
  end

  def self.generate_primary_key
    SecureRandom.uuid
  end

  def self.readable_type
    name.demodulize.underscore
  end

  delegate :readable_type, to: :class
end
