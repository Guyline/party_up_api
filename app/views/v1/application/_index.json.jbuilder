json.data do
  json.array! resources,
    partial: "resource",
    as: :resource
end

unless @includes.empty?
  json.included do
    included = @includes.each_with_object({}) do |association_name, result|
      resources.map(&association_name).flatten.compact.each do |associated|
        result[associated.public_id] ||= associated
      end
    end

    json.array! included.values,
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
