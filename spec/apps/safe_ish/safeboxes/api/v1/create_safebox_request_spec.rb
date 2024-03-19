# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Create safebox", type: %i[request database] do
  path "/api/v1/safeboxes" do
    post "Creates a safebox" do
      tags "Safeboxes"
      operationId "createSafebox"
      consumes SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      produces SafeIsh::Safeboxes::Api::ApplicationController::JSON_API_MEDIA_TYPE
      description "Creates a new safebox based on a UUID, a non-empty name and a password."
      parameter name: :safebox_params,
                in: :body,
                schema: { "$ref" => "#/components/schemas/new_safebox" }

      response "201", "Safebox successfully created" do
        schema "$ref" => "#/components/schemas/safebox"

        let(:safebox_params) do
          Safeboxes::Safeboxes::Domain::NewSafeboxEntityFactory.build_params
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
                  "self" => Safeboxes::Safeboxes::Infrastructure::Links::CreateSafeboxLink.build(
                    create_safebox_url
                  ),
                  "open" => Safeboxes::Safeboxes::Infrastructure::Links::OpenSafeboxLink.build(
                    open_safebox_url(safebox_params.dig(:data, :id))
                  ),
                  "getItems" => Safeboxes::Safeboxes::Infrastructure::Links::ListSafeboxItemsLink.build(
                    list_safebox_items_url(safebox_params.dig(:data, :id))
                  ),
                  "addItem" => Safeboxes::Safeboxes::Infrastructure::Links::AddSafeboxItemLink.build(
                    add_safebox_item_url(safebox_params.dig(:data, :id))
                  )
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
                    "header" => SafeIsh::Safeboxes::Api::ApplicationController::ACCEPT_HEADER
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
          Safeboxes::Safeboxes::Domain::NewSafeboxEntityFactory.build_params
        end

        before do
          Safeboxes::Safeboxes::Domain::NewSafeboxEntityFactory.create(id: safebox_params.dig(:data, :id))
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

        let(:safebox_params) do
          Safeboxes::Safeboxes::Domain::NewSafeboxEntityFactory.build_params(id: "uuid")
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

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:safebox_params) do
          Safeboxes::Safeboxes::Domain::NewSafeboxEntityFactory.build_params
        end

        before do
          allow(Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput).to receive(:new)
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
