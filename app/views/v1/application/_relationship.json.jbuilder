# json.links

json.data do
  if related.nil?
    json.nil!
  elsif related.is_a?(ApplicationRecord)
    json.id related.public_id
    json.type related.readable_type&.pluralize
  elsif related.respond_to?(:each)
    json.array! related do |relationship|
      json.id relationship.public_id
      json.type relationship.readable_type&.pluralize
    end
  end
end
