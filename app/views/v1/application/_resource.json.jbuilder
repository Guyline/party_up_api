json.type resource.readable_type.pluralize
json.id resource.id

if defined?(attributes_partial) && attributes_partial.is_a?(String)
  json.attributes do
    json.partial! attributes_partial,
      resource:
  end
end

json.relationships do
  resource.class.api_relationships.each do |name|
    associated = resource.send(name)
    next unless associated

    json.set! name do
      json.data do
        json.id associated.id
        json.type associated.readable_type&.pluralize
      end
    end
  end
end
