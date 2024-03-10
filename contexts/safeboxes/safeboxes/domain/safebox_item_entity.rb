# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxItemEntity < Shared::Domain::Aggregate
        attr_reader :id, :name, :safebox_id

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              name: attributes.fetch(:name),
              safebox_id: attributes.fetch(:safebox_id))
        end

        def initialize(id:, name:, safebox_id:)
          super()
          @id = SafeboxItemIdValueObject.new(value: id)
          @name = SafeboxItemNameValueObject.new(value: name)
          @safebox_id = SafeboxIdValueObject.new(value: safebox_id)
        end

        def to_primitives
          {
            id: id.value,
            name: name.value,
            safebox_id: safebox_id.value
          }
        end
      end
    end
  end
end
