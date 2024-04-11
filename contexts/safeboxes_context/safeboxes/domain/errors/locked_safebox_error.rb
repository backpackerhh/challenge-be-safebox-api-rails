# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      module Errors
        class LockedSafeboxError < StandardError
          attr_reader :id

          def initialize(id)
            super()
            @id = id
          end

          def message
            "Safebox locked"
          end

          def to_hash
            {
              title: message,
              detail: "Safebox with ID #{id} is locked",
              status: "423"
            }
          end
        end
      end
    end
  end
end
