json.attendees do
  json.partial! "relationship",
    related: resource.attendees
end

json.creator do
  json.partial! "relationship",
    related: resource.creator
end

json.invites do
  json.partial! "relationship",
    related: resource.invites
end
