# frozen_string_literal: true

module SafeIsh
  module Safeboxes
    module Api
      class ApplicationController < ActionController::API
        JSON_API_MEDIA_TYPE = "application/vnd.api+json"
        ACCEPT_HEADER = "Accept"
        CONTENT_TYPE_HEADER = "Content-Type"
        OPEN_SAFEBOX_HEADER = "X-SafeIsh-Password"
        AUTHORIZATION_HEADER = "Authorization"
        AUTHENTICATION_HEADER = "WWW-Authenticate"

        before_action :check_accept_header
        before_action :check_content_type_header
        around_action :set_content_type_header

        def body_params
          JSON.parse(request.body.read)
        end

        def query_params
          params.permit(:sort, page: {}).to_hash.deep_symbolize_keys
        end

        def successful_response(data, status: :ok)
          render json: data, status:
        end

        def failed_response(errors, status: :bad_request)
          errors = SharedContext::Infrastructure::Error.generate_from(errors)

          render json: { errors: }, status:
        end

        rescue_from StandardError, ScriptError do |e|
          error = SharedContext::Infrastructure::Errors::InternalServerError.new(e)

          failed_response(error, status: :internal_server_error)
        end

        rescue_from SharedContext::Domain::Errors::InvalidArgumentError do |e|
          failed_response(e, status: :unprocessable_entity)
        end

        rescue_from SharedContext::Infrastructure::Errors::NotAcceptableMediaTypeError do |e|
          failed_response(e, status: :not_acceptable)
        end

        rescue_from SharedContext::Infrastructure::Errors::UnsupportedMediaTypeError do |e|
          failed_response(e, status: :unsupported_media_type)
        end

        rescue_from SharedContext::Infrastructure::Errors::DuplicatedRecordError do |e|
          failed_response(e, status: :conflict)
        end

        rescue_from SharedContext::Infrastructure::Errors::RecordNotFoundError do |e|
          failed_response(e, status: :not_found)
        end

        rescue_from SafeboxesContext::Safeboxes::Domain::Errors::LockedSafeboxError do |e|
          failed_response(e, status: :locked)
        end

        rescue_from SafeboxesContext::Safeboxes::Domain::Errors::InvalidSafeboxPasswordError do |e|
          e.header = OPEN_SAFEBOX_HEADER

          failed_response(e, status: :unauthorized)
        end

        rescue_from SafeboxesContext::Safeboxes::Domain::Errors::InvalidSafeboxTokenError do |e|
          e.header = AUTHORIZATION_HEADER

          failed_response(e, status: :unauthorized)

          response.set_header(AUTHENTICATION_HEADER, "Bearer realm='Access to an open safebox'")
        end

        private

        def check_accept_header
          return if request.headers[ACCEPT_HEADER].to_s.include?(JSON_API_MEDIA_TYPE)

          raise SharedContext::Infrastructure::Errors::NotAcceptableMediaTypeError.new(
            request.headers[ACCEPT_HEADER],
            ACCEPT_HEADER
          )
        end

        def check_content_type_header
          return if request.headers[CONTENT_TYPE_HEADER].to_s.include?(JSON_API_MEDIA_TYPE)

          raise SharedContext::Infrastructure::Errors::UnsupportedMediaTypeError.new(
            request.headers[CONTENT_TYPE_HEADER],
            CONTENT_TYPE_HEADER
          )
        end

        def set_content_type_header
          yield
        ensure
          response.set_header(CONTENT_TYPE_HEADER, JSON_API_MEDIA_TYPE)
        end

        def extract_token_from_auth_header
          request.headers[AUTHORIZATION_HEADER].to_s.sub("Bearer ", "") # FIXME: naive approach
        end
      end
    end
  end
end
