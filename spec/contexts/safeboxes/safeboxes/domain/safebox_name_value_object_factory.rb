# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxNameValueObjectFactory
        def self.build(value = Faker::Name.name)
          value
        end

        def self.too_short
          SecureRandom.alphanumeric(SafeboxNameValueObject::MIN_LENGTH - 1)
        end

        def self.too_long
          SecureRandom.alphanumeric(SafeboxNameValueObject::MAX_LENGTH + 1)
        end
      end
    end
  end
end
