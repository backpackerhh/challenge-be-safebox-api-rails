# frozen_string_literal: true

require "rails_helper"

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it"s configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join("api").to_s

  # Validate body does not contain undocumented properties
  # NOTE: Bear in mind that in strict mode all properties are required
  # config.openapi_strict_schema_validation = true

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the "rswag:specs:swaggerize" rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe "...", openapi_spec: "v2/swagger.json"
  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        description: "SafeIsh API - The most secure safebox",
        version: "1.0.0",
        title: "SafeIsh API"
      },
      paths: {},
      components: {
        securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer
          }
        },
        schemas: {
          new_safebox: Shared::Infrastructure::SchemaValidator.load_schema("new_safebox"),
          safebox: Shared::Infrastructure::SchemaValidator.load_schema("safebox"),
          safebox_token: Shared::Infrastructure::SchemaValidator.load_schema("safebox_token"),
          safebox_items: Shared::Infrastructure::SchemaValidator.load_schema("safebox_items"),
          new_safebox_item: Shared::Infrastructure::SchemaValidator.load_schema("new_safebox_item"),
          api_error: Shared::Infrastructure::SchemaValidator.load_schema("api_error")
        }
      },
      servers: [
        {
          url: "https://{defaultHost}",
          variables: {
            defaultHost: {
              default: "www.example.com"
            }
          }
        }
      ]
    }
  }

  # Specify the format of the output Swagger file when running "rswag:specs:swaggerize".
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ":json" and ":yaml".
  config.openapi_format = :yaml
end
