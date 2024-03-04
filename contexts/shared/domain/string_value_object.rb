# frozen_string_literal: true

module Shared
  module Domain
    class StringValueObject < ValueObject
      value_type Types::Strict::String
    end
  end
end
