# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class InvalidPaginationValueError < StandardError
        attr_reader :invalid_parameter, :invalid_value

        def initialize(invalid_parameter, invalid_value)
          super()
          @invalid_parameter = invalid_parameter
          @invalid_value = invalid_value
        end

        def message
          "Invalid pagination value"
        end

        def to_hash
          {
            title: message,
            detail: "Invalid pagination value: #{invalid_value}. Only integer values greater than zero are accepted",
            status: "400",
            source: {
              parameter: "page[#{invalid_parameter}]"
            }
          }
        end
      end
    end
  end
end
