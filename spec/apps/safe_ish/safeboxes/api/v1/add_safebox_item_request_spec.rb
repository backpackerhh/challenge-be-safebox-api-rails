# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Add safebox item", type: %i[request database] do
  path "/api/v1/safeboxes/{id}/items" do
    post "Adds an item to a safebox" do
      tags "Safeboxes"
      operationId "addSafeboxItem"
      consumes SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
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
        let(:token) { SafeboxesContext::Safeboxes::Infrastructure::Utils.generate_token(id, password) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }
        let(:safebox_item_params) do
          SafeboxesContext::Safeboxes::Domain::SafeboxItemEntityFactory.build_params(safebox_id: id)
        end

        before do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(id:, password:)
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
                  "self" => SafeboxesContext::Safeboxes::Infrastructure::Links::AddSafeboxItemLink.build(
                    add_safebox_item_url(id)
                  ),
                  "getItems" => SafeboxesContext::Safeboxes::Infrastructure::Links::ListSafeboxItemsLink.build(
                    list_safebox_items_url(id)
                  )
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
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(id:)
        end

        after do |example|
          example.metadata[:response][:headers] = {
            SafeIsh::Safeboxes::Api::ApplicationController::AUTHENTICATION_HEADER => {
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
                    "header" => SafeIsh::Safeboxes::Api::ApplicationController::AUTHORIZATION_HEADER
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
                    "header" => SafeIsh::Safeboxes::Api::ApplicationController::ACCEPT_HEADER
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
                    "header" => SafeIsh::Safeboxes::Api::ApplicationController::CONTENT_TYPE_HEADER
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
        let(:token) { SafeboxesContext::Safeboxes::Infrastructure::Utils.generate_token(id, password) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }
        let(:safebox_item_params) do
          SafeboxesContext::Safeboxes::Domain::SafeboxItemEntityFactory.build_params(safebox_id: id, id: "uuid")
        end

        before do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(id:, password:)
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "Invalid schema error",
                  "detail" => Regexp.new("The property '#/data/id' value \"uuid\" did not match the regex"),
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
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(:locked, id:)
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
          allow(SafeboxesContext::Safeboxes::Infrastructure::AddSafeboxItemInput).to receive(:new)
            .and_raise(ArgumentError, "missing required argument")
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
