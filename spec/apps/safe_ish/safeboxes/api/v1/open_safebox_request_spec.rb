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
                required: true,
                example: "f626c808-648c-41fe-865d-c6062f3e0899"
      parameter name: "X-SafeIsh-Password",
                in: :header,
                schema: { type: :string },
                description: "Base64-encoded safebox password (use with another security mechanism such as HTTPS/SSL)",
                required: true,
                example: "ZXh0cmVtZWx5U2VjdXJlUGFzc3dvcmQ="

      response "200", "Safebox successfully opened" do
        schema "$ref" => "#/components/schemas/safebox_token"

        let(:"X-SafeIsh-Password") { Base64.encode64(password) }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }

        before do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(id:, password:)
        end

        after do |example|
          example.metadata[:response][:links] = {
            getItems: {
              operationId: "getSafeboxItems",
              parameters: {
                "path.id": "$request.path#/id",
                "header.Authorization": "$response.body#/data/id"
              }
            },
            addItem: {
              operationId: "addSafeboxItem",
              parameters: {
                "path.id": "$request.path#/id",
                "header.Authorization": "$response.body#/data/id"
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data).to match(
            {
              "data" => {
                "id" => String,
                "type" => "safeboxToken",
                "links" => {
                  "self" => SafeboxesContext::Safeboxes::Infrastructure::Links::OpenSafeboxLink.build(
                    open_safebox_url(id)
                  ),
                  "getItems" => SafeboxesContext::Safeboxes::Infrastructure::Links::ListSafeboxItemsLink.build(
                    list_safebox_items_url(id)
                  ),
                  "addItem" => SafeboxesContext::Safeboxes::Infrastructure::Links::AddSafeboxItemLink.build(
                    add_safebox_item_url(id)
                  )
                }
              }
            }
          )
        end
      end

      response "401", "Invalid password provided to open safebox" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"X-SafeIsh-Password") { Base64.encode64("fake") }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
        let(:password) { "secret" }

        before do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(id:, password:)
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Invalid password",
                  "detail" => "The provided password to open safebox with ID #{id} is not valid",
                  "status" => "401",
                  "source" => {
                    "header" => SafeIsh::Safeboxes::Api::ApplicationController::OPEN_SAFEBOX_HEADER
                  }
                }
              ]
            }
          )
        end
      end

      response "404", "Safebox not found" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
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
        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
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
        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
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

        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

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

        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
        let(:id) { "f626c808-648c-41fe-865d-c6062f3e0899" }

        before do
          allow(SafeboxesContext::Safeboxes::Infrastructure::OpenSafeboxInput).to receive(:new)
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
