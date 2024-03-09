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

      response "200", "Safebox contents successfully retrieved" do
        schema "$ref" => "#/components/schemas/safebox_items"

        let(:Authorization) { "Bearer <token>" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

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
              "data" => []
            }
          )
        end
      end

      response "401", "Invalid token provided to retrieve safebox items" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer <token>" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => []
            }
          )
        end
      end

      response "404", "Safebox not found" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer <token>" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => []
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

        let(:Authorization) { "Bearer <token>" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => []
            }
          )
        end
      end

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Authorization) { "Bearer <token>" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => []
            }
          )
        end
      end
    end
  end
end
