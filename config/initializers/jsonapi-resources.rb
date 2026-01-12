# NOTE: jsonapi-resources does not appear to work with Rails 8
#   If this gem is updated and can be used, the initializer configuration below can be used

# JSONAPI.configure do |config|
#   config.resource_cache = Rails.cache
#   # config.default_caching = true

#   # Options are :none, :offset, :paged, or a custom paginator name
#   config.default_paginator = :paged # default is :none

#   config.default_page_size = 25
#   config.maximum_page_size = 100

#   # config.resource_key_type = :uuid
#   config.json_key_format = :camelized_key

#   # Metadata
#   # Output record count in top level meta for find operation
#   config.top_level_meta_include_record_count = true
#   config.top_level_meta_record_count_key = :record_count

#   config.top_level_meta_include_page_count = true
#   config.top_level_meta_page_count_key = :page_count
# end

# JSONAPI::ActiveRelationResource.module_eval do
#   class << self
#     # Default method uses double quote (") character, which cannot be used in some cases
#     def quote(field)
#       "`#{field}`"
#     end
#   end
# end
