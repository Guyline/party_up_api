json.type resource.readable_type.pluralize
json.id resource.public_id

json.attributes do
  json.partial! "v1/#{resource.readable_type.pluralize}/#{resource.readable_type}",
    resource:
end

pp "Here!"
pp resource
pp resource.loaded_association_names

unless resource.loaded_association_names.empty?
  json.relationships do
    resource.loaded_association_names.each do |association|
      json.set! association do
        json.partial! "relationship",
          related: resource.send(association)
      end
    end
  end
end
