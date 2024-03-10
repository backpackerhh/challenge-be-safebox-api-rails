# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "List safebox items", type: %i[request database] do
  path "/api/v1/safeboxes/{id}/items" do
    get "Retrieves the content of a safebox" do
      tags "Safeboxes"
      operationId "getSafeboxItems"
      consumes SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      description "Retrieves the currently stored contents in the safebox identified by the given ID and opening token."
      parameter name: :id,
                in: :path,
                schema: { type: :string },
                description: "Safebox ID",
                required: true,
                example: "f626c808-648c-41fe-865d-c6062f3e0899"
      security [bearerAuth: []]

      def generate_token(id, password)
        repository = Safeboxes::Safeboxes::Infrastructure::PostgresSafeboxRepository.new
        token = repository.enable_opening_with_generated_token(id, password)

        token.id.value
      end

      response "200", "Safebox contents successfully retrieved" do
        schema "$ref" => "#/components/schemas/safebox_items"

        let(:Authorization) { "Bearer #{generate_token(id, password)}" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }

        before do
          safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create(id:, password:)

          Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(
            id: "932464d1-3434-4382-aeb9-50f21828b883",
            safebox_id: safebox.id.value,
            name: "Item 01"
          )
          Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(
            id: "baa7a07f-d972-4cfe-88b5-248c87c51d78",
            safebox_id: safebox.id.value,
            name: "Item 02"
          )
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
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create(id:)
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

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Record not found",
                  "detail" => "Record with ID #{id} does not exist",
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

      response "423", "Safebox is locked" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        before do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create(:locked, id:)
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
          allow(Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput).to receive(:new)
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
