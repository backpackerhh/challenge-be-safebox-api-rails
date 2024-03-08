# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxTokenEntity
        attr_reader :id

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id))
        end

        def initialize(id:)
          @id = SafeboxTokenIdValueObject.new(value: id)
        end

        def to_primitives
          {
            id: id.value
          }
        end
      end
    end
  end
end
