# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class OpenSafeboxController < ApplicationController
          def create
            input = SafeboxesContext::Safeboxes::Infrastructure::OpenSafeboxInput.new(
              id: params[:id],
              encoded_password: request.headers[OPEN_SAFEBOX_HEADER]
            )
            result = SafeboxesContext::Safeboxes::Application::OpenSafeboxUseCase.new.open(input:)

            result.on_success do |safebox_token|
              successful_response(
                SafeboxesContext::Safeboxes::Infrastructure::SafeboxTokenSerializer.new(
                  safebox_token,
                  params: {
                    self_url: open_safebox_url(params[:id]),
                    get_items_url: list_safebox_items_url(params[:id]),
                    add_item_url: add_safebox_item_url(params[:id])
                  }
                ),
                status: :ok
              )
            end
          end
        end
      end
    end
  end
end
