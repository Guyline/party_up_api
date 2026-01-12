json.data do
  json.array! resources,
    partial: "resource",
    as: :resource
end

if defined?(included) && included.is_a(Array)
  json.included do
    json.array! included,
      partial: "resource",
      as: :resource
  end
end

json.links do
  json.first URI::HTTP.build(
    {
      host: request.host,
      path: url_for(only_path: true, overwrite_params: nil),
      port: request.optional_port,
      query: request.query_parameters.except(:page).to_query
    }.compact_blank
  ).to_s
  json.prev prev_page_url resources
  json.next next_page_url resources
  json.last URI::HTTP.build(
    {
      host: request.host,
      path: url_for(only_path: true, overwrite_params: nil),
      port: request.optional_port,
      query: request.query_parameters.merge({page: resources.total_pages}).to_query
    }.compact_blank
  ).to_s
end
