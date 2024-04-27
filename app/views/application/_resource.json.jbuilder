json.type resource.class.name.downcase.pluralize
json.id resource.id

if defined?(attributes_partial) && attributes_partial.is_a?(String)
  json.attributes do
    json.partial! attributes_partial,
                  resource:
  end
end

json.relationships do
  resource.class.api_relationships.each do |name, type|
    json.set! name do
      json.data do
        json.id resource.send("#{name}_id")
        json.type type
      end
    end
  end
end
