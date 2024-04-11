# frozen_string_literal: true

module SharedContext
  module Domain
    module Errors
      class InvalidArgumentError < StandardError
        attr_reader :original_error

        def initialize(original_error)
          super()
          @original_error = original_error
        end

        def message
          "Invalid argument error"
        end

        def to_hash
          {
            title: message,
            detail: original_error.message,
            status: "422",
            source: {
              pointer: "/data" # FIXME: Find a way to be more specific here
            }
          }
        end
      end
    end
  end
end
