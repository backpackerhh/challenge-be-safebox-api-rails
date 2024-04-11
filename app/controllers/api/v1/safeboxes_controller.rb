# frozen_string_literal: true

module Api
  module V1
    class SafeboxesController < ApplicationController
      def create
        raw_safebox_params = body_params
        safebox = Safebox.create!(
          id: raw_safebox_params.dig("data", "id"),
          name: raw_safebox_params.dig("data", "attributes", "name"),
          password: raw_safebox_params.dig("data", "attributes", "password")
        )

        successful_response(SafeboxSerializer.new(safebox), status: :created)
      end

      def open
        safebox = Safebox.find(params[:id])

        if safebox.locked?
          raise LockedSafeboxError, safebox.id
        end

        if !safebox.authenticate_password(decoded_safebox_password)
          safebox.increment!(:failed_opening_attempts)

          raise InvalidSafeboxPasswordError, safebox.id
        end

        successful_response(
          SafeboxTokenSerializer.new(
            SafeboxToken.new(id: safebox.generate_token_for(:open)),
            params: { id: safebox.id }
          ),
          status: :ok
        )
      end

      private

      def decoded_safebox_password
        Base64.decode64(request.headers[OPEN_SAFEBOX_HEADER].to_s)
      end
    end
  end
end
