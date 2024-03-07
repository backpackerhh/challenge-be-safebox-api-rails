# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Open safebox", type: %i[request database] do
  path "/api/v1/safeboxes/{id}/open" do
    post "Opens a safebox" do
      tags "Safeboxes"
      operationId "openSafebox"
      consumes SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      description "Opens the safebox identified by the given ID and password."
      parameter name: :id,
                in: :path,
                schema: { type: :string },
                description: "Safebox ID",
                required: true
      parameter name: "X-SafeIsh-Password",
                in: :header,
                schema: { type: :string },
                description: "Base64-encoded safebox password (use with another security mechanism such as HTTPS/SSL)",
                required: true,
                example: "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ="

      response "200", "Safebox successfully opened" do
        schema "$ref" => "#/components/schemas/safebox_token"

        let(:"X-SafeIsh-Password") { "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ" }
        let(:id) { 1 }

        after do |example|
          example.metadata[:response][:links] = {
            getItems: {
              operationId: "getSafeboxItems",
              parameters: {
                "path.id": "$request.body#/id",
                "header.X-SafeIsh-Token": "$response.body#/data/id"
              }
            },
            addItem: {
              operationId: "addSafeboxItem",
              parameters: {
                "path.id": "$request.body#/id",
                "header.X-SafeIsh-Token": "$response.body#/data/id"
              }
            }
          }
        end

        run_test!
      end

      response "401", "Invalid password provided to open safebox" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"X-SafeIsh-Password") { "fake" }
        let(:id) { 1 }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "",
                  "detail" => "",
                  "status" => "401",
                  "source" => {}
                }
              ]
            }
          )
        end
      end

      response "404", "Safebox not found" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"X-SafeIsh-Password") { "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ" }
        let(:id) { 1 }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "",
                  "detail" => "",
                  "status" => "404",
                  "source" => {}
                }
              ]
            }
          )
        end
      end

      response "406", "Not acceptable media type" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Accept) { "application/json" }
        let(:"X-SafeIsh-Password") { "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ" }
        let(:id) { 1 }

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
        let(:"X-SafeIsh-Password") { "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ" }
        let(:id) { 1 }

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

        let(:"X-SafeIsh-Password") { "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ" }
        let(:id) { 1 }

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to match(
            {
              "errors" => [
                {
                  "title" => "",
                  "detail" => "",
                  "status" => "423",
                  "source" => {}
                }
              ]
            }
          )
        end
      end

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"X-SafeIsh-Password") { "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ" }
        let(:id) { 1 }

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
