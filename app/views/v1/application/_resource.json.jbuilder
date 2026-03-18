json.type resource.base_readable_type.pluralize
json.id resource.public_id

json.attributes do
  json.partial! "v1/#{resource.readable_type.pluralize}/attributes",
    resource:
end

json.relationships do
  json.partial! "v1/#{resource.readable_type.pluralize}/relationships",
    resource:
end
