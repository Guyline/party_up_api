json.holder do
  json.data do
    if resource.holder_public_id.nil?
      json.nil!
    else
      json.id resource.holder_public_id
      json.type "users"
    end
  end
end

json.item do
  json.data do
    if resource.item_public_id.nil?
      json.nil!
    else
      json.id resource.item_public_id
      json.type "items"
    end
  end
end

json.location do
  json.data do
    if resource.location_public_id.nil?
      json.nil!
    else
      json.id resource.location_public_id
      json.type "locations"
    end
  end
end

json.owners do
  json.partial! "relationship",
    related: resource.owners
end

json.ownerships do
  json.partial! "relationship",
    related: resource.ownerships
end

json.version do
  json.data do
    if resource.version_public_id.nil?
      json.nil!
    else
      json.id resource.version_public_id
      json.type "versions"
    end
  end
end
