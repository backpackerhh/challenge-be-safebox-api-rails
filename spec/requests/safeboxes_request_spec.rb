# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Create safebox", type: %i[request database] do
  path "/api/v1/safeboxes" do
    post "Creates a safebox" do
      tags "Safeboxes"
      operationId "createSafebox"
      consumes Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces Api::ApplicationController::JSON_API_MEDIA_TYPE
      description "Creates a new safebox based on a UUID, a non-empty name and a password."
      parameter name: :safebox_params,
                in: :body,
                schema: { "$ref" => "#/components/schemas/new_safebox" }

      response "201", "Safebox successfully created" do
        schema "$ref" => "#/components/schemas/safebox"

        let(:safebox_params) do
          Test::CreateSafeboxRequest.build(attributes_for(:safebox))
        end

        after do |example|
          example.metadata[:response][:links] = {
            open: {
              operationId: "openSafebox",
              parameters: {
                "path.id": "$request.body#/data/id",
                "header.X-SafeIsh-Password": "$request.body#/data/attributes/password"
              }
            },
            getItems: {
              operationId: "getSafeboxItems",
              parameters: {
                "path.id": "$request.body#/data/id"
              }
            },
            addItem: {
              operationId: "addSafeboxItem",
              parameters: {
                "path.id": "$request.body#/data/id"
              }
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)

          expect(data).to match(
            {
              "data" => {
                "id" => safebox_params.dig(:data, :id),
                "type" => "safebox",
                "attributes" => {
                  "name" => safebox_params.dig(:data, :attributes, :name)
                },
                "links" => {
                  "self" => CreateSafeboxLink.build,
                  "open" => OpenSafeboxLink.build(safebox_params.dig(:data, :id)),
                  "getItems" => ListSafeboxItemsLink.build(safebox_params.dig(:data, :id)),
                  "addItem" => AddSafeboxItemLink.build(safebox_params.dig(:data, :id))
                }
              }
            }
          )
        end
      end

      response "406", "Not acceptable media type" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:Accept) { "application/json" }
        let(:safebox_params) { {} }

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

      response "409", "Safebox already exists" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:safebox_params) do
          Test::CreateSafeboxRequest.build(attributes_for(:safebox))
        end

        before do
          create(:safebox, id: safebox_params.dig(:data, :id))
        end

        run_test! do |response|
          errors = JSON.parse(response.body)

          expect(errors).to eq(
            {
              "errors" => [
                {
                  "title" => "Duplicated record",
                  "detail" => "Safebox with ID #{safebox_params.dig(:data, :id)} already exists",
                  "status" => "409",
                  "source" => {
                    "pointer" => "/data/id"
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
        let(:safebox_params) { {} }

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

        let(:safebox_params) do
          Test::CreateSafeboxRequest.build(attributes_for(:safebox, id: "uuid"))
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

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:safebox_params) do
          Test::CreateSafeboxRequest.build(attributes_for(:safebox))
        end

        before do
          allow(Safebox).to receive(:create!).and_raise(ArgumentError, "missing required argument")
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

  path "/api/v1/safeboxes/{id}/open" do
    post "Opens a safebox" do
      tags "Safeboxes"
      operationId "openSafebox"
      consumes Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces Api::ApplicationController::JSON_API_MEDIA_TYPE
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
          create(:safebox, id:, password:)
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
                  "self" => OpenSafeboxLink.build(id),
                  "getItems" => ListSafeboxItemsLink.build(id),
                  "addItem" => AddSafeboxItemLink.build(id)
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
          create(:safebox, id:, password:)
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
                    "header" => Api::ApplicationController::OPEN_SAFEBOX_HEADER
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

        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
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

        let(:"X-SafeIsh-Password") { "it-does-not-matter" }
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
  end
end
