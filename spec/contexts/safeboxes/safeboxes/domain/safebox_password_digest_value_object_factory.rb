# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxPasswordDigestValueObjectFactory
        def self.build(value = Faker::Internet.password)
          Base64.encode64(value)
        end
      end
    end
  end
end
