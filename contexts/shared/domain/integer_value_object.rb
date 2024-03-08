# frozen_string_literal: true

module Shared
  module Domain
    class IntegerValueObject < ValueObject
      value_type Types::Strict::Integer
    end
  end
end
