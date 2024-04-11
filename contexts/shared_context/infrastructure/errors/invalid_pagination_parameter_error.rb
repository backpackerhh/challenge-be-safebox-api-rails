# frozen_string_literal: true

module SharedContext
  module Infrastructure
    module Errors
      class InvalidPaginationParameterError < StandardError
        attr_reader :invalid_parameter

        def initialize(invalid_parameter)
          super()
          @invalid_parameter = invalid_parameter
        end

        def message
          "Invalid pagination parameter"
        end

        def to_hash
          {
            title: message,
            detail: "Invalid pagination parameter: #{invalid_parameter}. Only 'number' and 'size' are accepted",
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
