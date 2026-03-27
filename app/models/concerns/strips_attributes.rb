module StripsAttributes
  extend ActiveSupport::Concern

  included do
    before_validation ->(model) {
      model.attributes.each do |attribute, value|
        if value.respond_to? :strip
          value.strip!
          model[attribute] = nil if value.empty?
        end
      end
    }
  end
end
