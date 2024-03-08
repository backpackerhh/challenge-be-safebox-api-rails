# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxFailedOpeningAttemptsValueObject < Shared::Domain::IntegerValueObject
        MAX_ATTEMPTS_BEFORE_LOCKING = 3

        value_type Types::Strict::Integer.constrained(gteq: 0, lteq: MAX_ATTEMPTS_BEFORE_LOCKING)
      end
    end
  end
end
