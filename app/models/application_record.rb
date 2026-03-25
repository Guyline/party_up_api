class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # before_create do
  #   self.id ||= ApplicationRecord.generate_primary_key unless type_for_attribute(:id).type == :integer
  # end

  # before_save :set_associated_public_ids

  self.implicit_order_column = :created_at

  def all_association_names
    self.class.reflect_on_all_associations.map(&:name).sort!
  end

  def loaded_association_names
    all_association_names.select { |name| association(name).loaded? }.sort!
  end

  ##
  # Sets cached value of #public_id from all belongs_to associations.
  # Assumes presence of *_public_id attribute based on foreign key in association
  #   (e.g. association with "entity_id" foreign key will attempt to fill "entity_public_id").
  #
  def set_associated_public_ids(force: false)
    self.class.reflect_on_all_associations(:belongs_to).each do |reflection|
      foreign_key = reflection.foreign_key
      public_foreign_key = foreign_key.gsub(/(.*)_id$/, '\1_public_id').to_sym

      next unless respond_to?(public_foreign_key)

      if force || self[public_foreign_key].nil? || attribute_changed?(foreign_key)
        self[public_foreign_key] = send(reflection.name)&.public_id
      end
    end
    self
  end

  class << self
    # def generate_primary_key
    #   SecureRandom.uuid
    # end

    def readable_type
      name.demodulize.underscore
    end

    def base_readable_type
      base_class.name.demodulize.underscore
    end
  end

  delegate :readable_type, :base_readable_type, to: :class
end
