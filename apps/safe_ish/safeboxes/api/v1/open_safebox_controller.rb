# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class OpenSafeboxController < ApplicationController
          def create
            input = ::Safeboxes::Safeboxes::Infrastructure::OpenSafeboxInput.new(
              id: params[:id],
              encoded_password: request.headers[OPEN_SAFEBOX_HEADER]
            )
            result = ::Safeboxes::Safeboxes::Application::OpenSafeboxUseCase.new.open(input:)

            result.on_success do |safebox_token|
              successful_response(
                ::Safeboxes::Safeboxes::Infrastructure::SafeboxTokenSerializer.new(
                  safebox_token,
                  params: {
                    safebox_id: params[:id]
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
