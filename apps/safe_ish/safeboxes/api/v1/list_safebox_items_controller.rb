# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class ListSafeboxItemsController < ApplicationController
          def index
            input = ::Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput.new(
              id: params[:id],
              token: extract_token_from_auth_header
            )
            result = ::Safeboxes::Safeboxes::Application::ListSafeboxItemsUseCase.new.retrieve_all(input:)

            result.on_success do |safebox_items|
              successful_response(
                ::Safeboxes::Safeboxes::Infrastructure::SafeboxItemSerializer.new(safebox_items),
                status: :ok
              )
            end
          end
        end
      end
    end
  end
end
