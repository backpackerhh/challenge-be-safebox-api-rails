# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxPasswordValueObjectFactory
        def self.build(value = Faker::Internet.password)
          value
        end

        def self.too_short
          SecureRandom.alphanumeric(SafeboxPasswordValueObject::MIN_BYTESIZE - 1)
        end

        def self.too_long
          SecureRandom.alphanumeric(SafeboxPasswordValueObject::MAX_BYTESIZE + 1)
        end
      end
    end
  end
end
