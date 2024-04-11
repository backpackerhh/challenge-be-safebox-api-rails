# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      class SafeboxNameValueObject < SharedContext::Domain::StringValueObject
        MIN_LENGTH = 3
        MAX_LENGTH = 50

        value_type Types::Strict::String.constrained(size: MIN_LENGTH..MAX_LENGTH).constructor(&:strip)
      end
    end
  end
end
