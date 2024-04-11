# frozen_string_literal: true

module SharedContext
  module Domain
    class UuidValueObject < ValueObject
      value_type Types::Strict::String.constrained(uuid_v4: true)
    end
  end
end
