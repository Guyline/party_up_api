class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create do
    self.id ||= SecureRandom.uuid unless type_for_attribute(:id).type == :integer
  end

  self.implicit_order_column = :created_at

  def self.api_relationships
    belongs_to_associations = reflect_on_all_associations(:belongs_to)
    belongs_to_associations.map do |association|
      [association.name, association.klass.name.downcase.pluralize]
    end.to_h
  end
end
