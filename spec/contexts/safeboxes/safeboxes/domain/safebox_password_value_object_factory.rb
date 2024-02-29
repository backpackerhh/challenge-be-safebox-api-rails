# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxPasswordValueObjectFactory
        def self.build(value = Faker::Internet.password)
          value
        end
      end
    end
  end
end
