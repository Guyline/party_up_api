class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # before_create do
  #   self.id ||= ApplicationRecord.generate_primary_key unless type_for_attribute(:id).type == :integer
  # end

  self.implicit_order_column = :created_at

  def all_association_names
    self.class.reflect_on_all_associations.map(&:name).sort!
  end

  def loaded_association_names
    pp all_association_names
    all_association_names.select { |name| association(name).loaded? }.sort!
  end

  class << self
    # def generate_primary_key
    #   SecureRandom.uuid
    # end

    def readable_type
      name.demodulize.underscore
    end
  end

  delegate :readable_type, to: :class
end
