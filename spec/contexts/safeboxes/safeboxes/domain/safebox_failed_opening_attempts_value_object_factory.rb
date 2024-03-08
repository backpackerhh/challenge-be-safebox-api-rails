# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxFailedOpeningAttemptsValueObjectFactory
        def self.build(value = 0)
          value
        end

        def self.locked
          SafeboxFailedOpeningAttemptsValueObject::MAX_ATTEMPTS_BEFORE_LOCKING
        end
      end
    end
  end
end
