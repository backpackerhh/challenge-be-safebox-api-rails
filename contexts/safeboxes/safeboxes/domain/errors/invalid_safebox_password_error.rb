# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      module Errors
        class InvalidSafeboxPasswordError < StandardError
          attr_reader :id
          attr_accessor :header

          def initialize(id)
            super()
            @id = id
          end

          def message
            "Invalid password"
          end

          def to_hash
            {
              title: message,
              detail: "The provided password to open safebox with ID #{id} is not valid",
              status: "401",
              source: {
                header:
              }
            }
          end
        end
      end
    end
  end
end
