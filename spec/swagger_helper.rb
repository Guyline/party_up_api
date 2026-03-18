RSpec.configure do |config|
  config.openapi_root = Rails.root.to_s + "/openapi"

  config.openapi_specs = {
    "v1/openapi.yaml" => {
      openapi: "3.1.1",
      info: {
        title: "API v1",
        version: "v1"
      },
      servers: [
        {
          url: "{protocol}://{defaultHost}/v1",
          variables: {
            defaultHost: {
              default: "localhost"
            },
            protocol: {
              default: :https
            }
          }
        }
      ],

      components: {
        schemas: {},
        parameters: {
          order_param: {
            description: "Specifies the direction of paginated results (ascending or descending).",
            in: :query,
            name: "order",
            required: false,
            schema: {
              default: "asc",
              enum: [
                "asc",
                "desc"
              ],
              type: :string
            }
          },
          page_param: {
            description: "Specifies page of paginated results to fetch.",
            default: 1,
            in: :query,
            name: "page",
            required: false,
            type: :integer
          },
          per_page_param: {
            description: "Specifies number of results to include per page.",
            default: 20,
            in: :query,
            name: "per_page",
            required: false,
            type: :integer
          },
          sort_param: {
            description: "Specifies entity attribute to use when sorting results.",
            default: "created_at",
            in: :query,
            name: "sort",
            required: false,
            type: :string
          }
        }
      }
    }
  }
end
