json.expandables do
  json.partial! "relationship",
    related: resource.expandables
end

json.expansions do
  json.partial! "relationship",
    related: resource.expansions
end
