# frozen_string_literal: true

module SharedContext
  module Infrastructure
    module Errors
      class InternalServerError < StandardError
        attr_reader :original_error

        def initialize(original_error)
          super()
          @original_error = original_error
        end

        def message
          "Internal server error"
        end

        def to_hash
          {
            title: message,
            detail: "Internal server error: #{original_error.message}",
            status: "500",
            meta: {
              backtrace: original_error.backtrace[0...5] # FIXME: remove before moving to production
            }
          }
        end
      end
    end
  end
end
