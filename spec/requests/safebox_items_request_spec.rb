# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "List safebox items", type: %i[request database] do
  path "/api/v1/safeboxes/{id}/items" do
    get "Retrieves the content of a safebox" do
      tags "Safeboxes"
      operationId "getSafeboxItems"
      consumes Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces Api::ApplicationController::JSON_API_MEDIA_TYPE
      description "Retrieves the currently stored contents in the safebox identified by the given ID and opening token."
      parameter name: :id,
                in: :path,
                schema: { type: :string },
                description: "Safebox ID",
                required: true,
                example: "f626c808-648c-41fe-865d-c6062f3e0899"
      parameter name: :sort,
                in: :query,
                schema: { type: :string },
                explode: false,
                required: false,
                description: "Comma-separated sorting fields: name, created_at" # FIXME: make list dynamic
      parameter name: "page[number]",
                in: :query,
                description: "Page number",
                schema: { type: :integer },
                example: 1,
                required: false
      parameter name: "page[size]",
                in: :query,
                description: "Number of elements per page",
                schema: { type: :integer },
                example: 10,
                required: false
      security [bearerAuth: []]

      response "200", "Safebox contents successfully retrieved" do
        schema "$ref" => "#/components/schemas/safebox_items"

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { Test::Utils.generate_token(id) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }

        before do
          safebox = create(:safebox, id:, password:)

          create(:safebox_item,
                 id: "932464d1-3434-4382-aeb9-50f21828b883",
                 safebox:,
                 name: "Item 01")
          create(:safebox_item,
                 id: "baa7a07f-d972-4cfe-88b5-248c87c51d78",
                 safebox:,
                 name: "Item 02")
        end

        after do |example|
          example.metadata[:response][:links] = {
            addItem: {
              operationId: "addSafeboxItem",
              parameters: {
                "path.id": "$request.path#/id",
                "header.Authorization": "$request.header.Authorization"
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data).to match(
            {
              "data" => [
                {
                  "id" => "932464d1-3434-4382-aeb9-50f21828b883",
                  "type" => "safeboxItem",
                  "attributes" => {
                    "name" => "Item 01"
                  },
                  "relationships" => {
                    "safebox" => {
                      "data" => {
                        "id" => id,
                        "type" => "safebox"
                      }
                    }
                  }
                },
                {
                  "id" => "baa7a07f-d972-4cfe-88b5-248c87c51d78",
                  "type" => "safeboxItem",
                  "attributes" => {
                    "name" => "Item 02"
                  },
                  "relationships" => {
                    "safebox" => {
                      "data" => {
                        "id" => id,
                        "type" => "safebox"
                      }
                    }
                  }
                }
              ],
              "links" => ListSafeboxItemsCollectionLinks.build(id, {}, 2)
            }
          )
        end
      end

      response "400", "Invalid parameters" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { Test::Utils.generate_token(id) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }
        let(:sort) { "invalidParameter" }
        let(:"page[number]") { -1 }

        before do
          create(:safebox, id:, password:)
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Invalid sorting parameter",
                  "detail" => "Invalid sorting parameter: invalid_parameter",
                  "status" => "400",
                  "source" => {
                    "parameter" => "sort[invalid_parameter]"
                  }
                },
                {
                  "title" => "Invalid pagination value",
                  "detail" => "Invalid pagination value: -1. Only integer values greater than zero are accepted",
                  "status" => "400",
                  "source" => {
                    "parameter" => "page[number]"
                  }
                }
              ]
            }
          )
        end
      end

      response "401", "Invalid token provided to retrieve safebox items" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer fake-token" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        before do
          create(:safebox, id:)
        end

        after do |example|
          example.metadata[:response][:headers] = {
            Api::ApplicationController::AUTHENTICATION_HEADER => {
              schema: {
                type: "string",
                description: "Indicates what authentication schemes can be used to access the resource."
              }
            }
          }
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Invalid token",
                  "detail" => "The provided token for safebox with ID #{id} is not valid",
                  "status" => "401",
                  "source" => {
                    "header" => Api::ApplicationController::AUTHORIZATION_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "404", "Safebox not found" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Record not found",
                  "detail" => "Safebox with ID #{id} does not exist",
                  "status" => "404"
                }
              ]
            }
          )
        end
      end

      response "406", "Not acceptable media type" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Accept) { "application/json" }
        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Not acceptable media type",
                  "detail" => "Not acceptable media type: application/json",
                  "status" => "406",
                  "source" => {
                    "header" => Api::ApplicationController::ACCEPT_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "415", "Unsupported media type" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"Content-Type") { "application/json" }
        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Unsupported media type",
                  "detail" => "Unsupported media type: application/json",
                  "status" => "415",
                  "source" => {
                    "header" => Api::ApplicationController::CONTENT_TYPE_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "423", "Safebox is locked" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        before do
          create(:safebox, :locked, id:)
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "Safebox locked",
                  "detail" => "Safebox with ID #{id} is locked",
                  "status" => "423"
                }
              ]
            }
          )
        end
      end

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        before do
          allow(Safebox).to receive(:find).and_raise(ArgumentError, "missing required argument")
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "Internal server error",
                  "detail" => "Internal server error: missing required argument",
                  "status" => "500",
                  "meta" => Hash
                }
              ]
            }
          )
        end
      end
    end

    post "Adds an item to a safebox" do
      tags "Safeboxes"
      operationId "addSafeboxItem"
      consumes Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces Api::ApplicationController::JSON_API_MEDIA_TYPE
      description "Inserts new contents in the safebox identified by the given ID and opening token."
      parameter name: :id,
                in: :path,
                schema: { type: :string },
                description: "Safebox ID",
                required: true,
                example: "f626c808-648c-41fe-865d-c6062f3e0899"
      parameter name: :safebox_item_params,
                in: :body,
                schema: { "$ref" => "#/components/schemas/new_safebox_item" }
      security [bearerAuth: []]

      response "201", "Safebox content successfully added" do
        schema "$ref" => "#/components/schemas/safebox_item"

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { Test::Utils.generate_token(id) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }
        let(:safebox_item_params) do
          Test::CreateSafeboxItemRequest.build(attributes_for(:safebox_item).merge(safebox_id: id))
        end

        before do
          create(:safebox, id:, password:)
        end

        after do |example|
          example.metadata[:response][:links] = {
            getItems: {
              operationId: "getSafeboxItems",
              parameters: {
                "path.id": "$request.path#/id",
                "header.Authorization": "$request.header.Authorization"
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data).to match(
            {
              "data" => {
                "id" => safebox_item_params.dig(:data, :id),
                "type" => "safeboxItem",
                "attributes" => {
                  "name" => safebox_item_params.dig(:data, :attributes, :name)
                },
                "relationships" => {
                  "safebox" => {
                    "data" => {
                      "id" => safebox_item_params.dig(:data, :relationships, :safebox, :data, :id),
                      "type" => "safebox"
                    }
                  }
                },
                "links" => {
                  "self" => AddSafeboxItemLink.build(id),
                  "getItems" => ListSafeboxItemsLink.build(id)
                }
              }
            }
          )
        end
      end

      response "401", "Invalid token provided to retrieve safebox items" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer fake-token" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:safebox_item_params) { {} }

        before do
          create(:safebox, id:)
        end

        after do |example|
          example.metadata[:response][:headers] = {
            Api::ApplicationController::AUTHENTICATION_HEADER => {
              schema: {
                type: "string",
                description: "Indicates what authentication schemes can be used to access the resource."
              }
            }
          }
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Invalid token",
                  "detail" => "The provided token for safebox with ID #{id} is not valid",
                  "status" => "401",
                  "source" => {
                    "header" => Api::ApplicationController::AUTHORIZATION_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "404", "Safebox not found" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:safebox_item_params) { {} }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Record not found",
                  "detail" => "Safebox with ID #{id} does not exist",
                  "status" => "404"
                }
              ]
            }
          )
        end
      end

      response "406", "Not acceptable media type" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Accept) { "application/json" }
        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:safebox_item_params) { {} }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Not acceptable media type",
                  "detail" => "Not acceptable media type: application/json",
                  "status" => "406",
                  "source" => {
                    "header" => Api::ApplicationController::ACCEPT_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "415", "Unsupported media type" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"Content-Type") { "application/json" }
        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:safebox_item_params) { {} }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Unsupported media type",
                  "detail" => "Unsupported media type: application/json",
                  "status" => "415",
                  "source" => {
                    "header" => Api::ApplicationController::CONTENT_TYPE_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "422", "Malformed expected data" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer #{token}" }
        let(:token) { Test::Utils.generate_token(id) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }
        let(:safebox_item_params) do
          Test::CreateSafeboxItemRequest.build(attributes_for(:safebox_item).merge(safebox_id: id, id: "uuid"))
        end

        before do
          create(:safebox, id:, password:)
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "Invalid argument error",
                  "detail" => "Id can't be blank",
                  "status" => "422",
                  "source" => {
                    "pointer" => "/data/id"
                  }
                },
                {
                  "title" => "Invalid argument error",
                  "detail" => "Id is not a valid UUID",
                  "status" => "422",
                  "source" => {
                    "pointer" => "/data/id"
                  }
                }
              ]
            }
          )
        end
      end

      response "423", "Safebox is locked" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:safebox_item_params) { {} }

        before do
          create(:safebox, :locked, id:)
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "Safebox locked",
                  "detail" => "Safebox with ID #{id} is locked",
                  "status" => "423"
                }
              ]
            }
          )
        end
      end

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:safebox_item_params) { {} }

        before do
          allow(Safebox).to receive(:find).and_raise(ArgumentError, "missing required argument")
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "Internal server error",
                  "detail" => "Internal server error: missing required argument",
                  "status" => "500",
                  "meta" => Hash
                }
              ]
            }
          )
        end
      end
    end
  end
end
