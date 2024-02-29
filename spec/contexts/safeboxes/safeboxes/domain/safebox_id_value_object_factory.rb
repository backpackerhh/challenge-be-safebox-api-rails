# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxIdValueObjectFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
