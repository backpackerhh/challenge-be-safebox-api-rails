# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class SchemaValidationError < StandardError
        attr_reader :original_error

        def initialize(original_error)
          super()
          @original_error = original_error
        end

        def message
          "Invalid schema error"
        end

        def to_hash
          {
            title: message,
            detail: original_error.fetch(:message),
            status: "422",
            source: {
              pointer: original_error.fetch(:fragment)[1..]
            }
          }
        end
      end
    end
  end
end
