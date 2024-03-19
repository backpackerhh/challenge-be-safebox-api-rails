# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class AddSafeboxItemController < ApplicationController
          def create
            input = ::Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput.new(
              raw_data: body_params,
              safebox_id: params[:id],
              token: extract_token_from_auth_header
            )
            result = ::Safeboxes::Safeboxes::Application::AddSafeboxItemUseCase.new.create(input:)

            result.on_success do |safebox_item|
              successful_response(
                ::Safeboxes::Safeboxes::Infrastructure::SafeboxItemSerializer.new(
                  safebox_item,
                  params: {
                    self_url: add_safebox_item_url(params[:id]),
                    get_items_url: list_safebox_items_url(params[:id])
                  }
                ),
                status: :created
              )
            end

            result.on_failure do |errors|
              failed_response(errors, status: :unprocessable_entity)
            end
          end
        end
      end
    end
  end
end
