# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      class SafeboxPasswordValueObject < SharedContext::Domain::StringValueObject
        MIN_BYTESIZE = 6
        MAX_BYTESIZE = 72

        value_type Types::Strict::String.constrained(bytesize: MIN_BYTESIZE..MAX_BYTESIZE)
      end
    end
  end
end
