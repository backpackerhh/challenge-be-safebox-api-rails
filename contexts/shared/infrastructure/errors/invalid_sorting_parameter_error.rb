# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class InvalidSortingParameterError < StandardError
        attr_reader :invalid_parameter

        def initialize(invalid_parameter)
          super()
          @invalid_parameter = invalid_parameter
        end

        def message
          "Invalid sorting parameter"
        end

        def to_hash
          {
            title: message,
            detail: "Invalid sorting parameter: #{invalid_parameter}",
            status: "400",
            source: {
              parameter: "sort[#{invalid_parameter}]"
            }
          }
        end
      end
    end
  end
end
