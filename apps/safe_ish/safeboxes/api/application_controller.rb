# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      class ApplicationController < ActionController::API
        def body_params
          JSON.parse(request.body.read)
        end
      end
    end
  end
end
