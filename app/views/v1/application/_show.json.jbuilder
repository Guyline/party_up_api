json.data do
  json.partial! "resource",
    resource:,
    attributes_partial:
end
json.links do
  json.self request.original_url
  if defined?(link_related)
    json.related link_related
  end
end
