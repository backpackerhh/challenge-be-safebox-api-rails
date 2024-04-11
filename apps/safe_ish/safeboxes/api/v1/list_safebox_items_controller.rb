# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class ListSafeboxItemsController < ApplicationController
          def index
            input = SafeboxesContext::Safeboxes::Infrastructure::ListSafeboxItemsInput.new(
              query_params:,
              id: params[:id],
              token: extract_token_from_auth_header
            )
            result = SafeboxesContext::Safeboxes::Application::ListSafeboxItemsUseCase.new.retrieve_all(input:)

            result.on_success do |safebox_items, total_safebox_items|
              successful_response(
                SafeboxesContext::Safeboxes::Infrastructure::SafeboxItemCollectionSerializer.new(
                  safebox_items,
                  is_collection: true,
                  links: build_links_for(params[:id], query_params, total_safebox_items)
                ),
                status: :ok
              )
            end

            result.on_failure do |errors|
              failed_response(errors, status: :bad_request)
            end
          end

          private

          def build_links_for(safebox_id, query_params, total_count)
            SafeboxesContext::Safeboxes::Infrastructure::Links::ListSafeboxItemsCollectionLinks.build(
              {
                self_url: list_safebox_items_url(safebox_id),
                add_item_url: add_safebox_item_url(safebox_id),
                self_url_lambda: ->(params) { list_safebox_items_url(safebox_id, params) }
              },
              query_params,
              total_count
            )
          end
        end
      end
    end
  end
end
