# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Create safebox", type: :request do
  path "/api/v1/safeboxes" do
    post "Creates a safebox" do
      tags "Safeboxes"
      operationId "createSafebox"
      consumes "application/vnd.api+json"
      produces "application/vnd.api+json"
      description "Creates a new safebox based on a UUID, a non-empty name and a password."
      parameter name: :safebox_params,
                in: :body,
                schema: { "$ref" => "#/components/schemas/new_safebox" }

      response "201", "Safebox successfully created" do
        let(:safebox_params) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build_params
        end

        after do |example|
          example.metadata[:response][:links] = {
            open: {
              operationId: "openSafebox",
              parameters: {
                "path.id": "$request.body#/id",
                "header.X-SafeIsh-Password": "$request.body#/password"
              }
            },
            getItems: {
              operationId: "getSafeboxItems",
              parameters: {
                "path.id": "$request.body#/id"
              }
            },
            addItem: {
              operationId: "addSafeboxItem",
              parameters: {
                "path.id": "$request.body#/id"
              }
            }
          }
        end

        run_test!
      end

      response "409", "Safebox already exists" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:safebox_params) do
          { data: {} }
        end

        run_test!
      end

      response "422", "Malformed expected data" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:safebox_params) do
          { data: {} }
        end

        run_test!
      end

      response "500", "Unexpected API error" do
        schema "$ref" => "#/components/schemas/api_error"

        let(:safebox_params) do
          { data: {} }
        end

        run_test!
      end
    end
  end
end
