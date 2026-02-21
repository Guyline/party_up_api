json.data do
  json.partial! "resource",
    resource:
end

json.links do
  json.self request.original_url
  if defined?(link_related)
    json.related link_related
  end
end
