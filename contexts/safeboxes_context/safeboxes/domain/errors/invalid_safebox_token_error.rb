# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      module Errors
        class InvalidSafeboxTokenError < StandardError
          attr_reader :id
          attr_accessor :header

          def initialize(id)
            super()
            @id = id
          end

          def message
            "Invalid token"
          end

          def to_hash
            {
              title: message,
              detail: "The provided token for safebox with ID #{id} is not valid",
              status: "401",
              source: {
                header: header || "Authorization"
              }
            }
          end
        end
      end
    end
  end
end
