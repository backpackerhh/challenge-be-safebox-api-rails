# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxPasswordValueObject < Shared::Domain::StringValueObject
        MIN_BYTESIZE = 6
        MAX_BYTESIZE = 72

        value_type Types::Strict::String.constrained(bytesize: MIN_BYTESIZE..MAX_BYTESIZE)
      end
    end
  end
end
