require "swagger_helper"

describe "Party Up API", openapi_spec: "v1/openapi.yaml" do
  path "/items" do
    get "Retrieves all items" do
      tags "Item"
      consumes "application/json"

      parameter schema: {
        "$ref" => "#/components/parameters/page_param"
      }
      parameter schema: {
        "$ref" => "#/components/parameters/per_page_param"
      }
      parameter schema: {
        "$ref" => "#/components/parameters/sort_param"
      }
      parameter schema: {
        "$ref" => "#/components/parameters/order_param"
      }
    end
  end
end
