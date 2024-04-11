# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      class SafeboxFailedOpeningAttemptsValueObject < SharedContext::Domain::IntegerValueObject
        MAX_ATTEMPTS_BEFORE_LOCKING = 3

        value_type Types::Strict::Integer.constrained(gteq: 0, lteq: MAX_ATTEMPTS_BEFORE_LOCKING)
      end
    end
  end
end
