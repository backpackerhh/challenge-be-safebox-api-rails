# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxItemIdValueObjectFactory
        def self.build(value = SecureRandom.uuid)
          value
        end
      end
    end
  end
end
