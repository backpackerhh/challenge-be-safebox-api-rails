# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      module V1
        class CreateSafeboxController < ApplicationController
          def create
            render json: {}, status: :ok
          end
        end
      end
    end
  end
end
