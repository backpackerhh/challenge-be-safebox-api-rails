# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class ListSafeboxItemsController < ApplicationController
          def index
            input = ::Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput.new(
              query_params:,
              id: params[:id],
              token: extract_token_from_auth_header
            )
            result = ::Safeboxes::Safeboxes::Application::ListSafeboxItemsUseCase.new.retrieve_all(input:)

            result.on_success do |safebox_items|
              successful_response(
                ::Safeboxes::Safeboxes::Infrastructure::SafeboxItemCollectionSerializer.new(
                  safebox_items,
                  is_collection: true,
                  links: ::Safeboxes::Safeboxes::Infrastructure::Links::ListSafeboxItemsCollectionLinks.build(
                    params[:id]
                  )
                ),
                status: :ok
              )
            end

            result.on_failure do |errors|
              failed_response(errors, status: :bad_request)
            end
          end
        end
      end
    end
  end
end
