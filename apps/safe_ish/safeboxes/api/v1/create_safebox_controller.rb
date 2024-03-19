# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class CreateSafeboxController < ApplicationController
          def create
            input = ::Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput.new(raw_data: body_params)
            result = ::Safeboxes::Safeboxes::Application::CreateSafeboxUseCase.new.create(input:)

            result.on_success do |safebox|
              successful_response(
                ::Safeboxes::Safeboxes::Infrastructure::SafeboxSerializer.new(
                  safebox,
                  params: {
                    self_url: create_safebox_url,
                    open_url: open_safebox_url(safebox.id.value),
                    get_items_url: list_safebox_items_url(safebox.id.value),
                    add_item_url: add_safebox_item_url(safebox.id.value)
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
