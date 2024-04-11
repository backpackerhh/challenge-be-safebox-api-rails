# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      class SafeboxItemEntity < SharedContext::Domain::Aggregate
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

        # Workaround for a known limitation of jsonapi-serializers
        #
        # @see https://github.com/jsonapi-serializer/jsonapi-serializer/issues/53
        def safebox_relationship_id
          safebox_id.value
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
