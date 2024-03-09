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
                ::Safeboxes::Safeboxes::Infrastructure::SafeboxSerializer.new(safebox),
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
