# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class PostgresSafeboxItemRepository
        def all(safebox_id)
          safebox_items = SafeboxItemRecord.where(safebox_id:).order(:created_at)

          safebox_items.map do |safebox_item|
            Domain::SafeboxItemEntity.from_primitives(
              id: safebox_item.id,
              name: safebox_item.name,
              safebox_id: safebox_item.safebox_id
            )
          end
        end

        def find_by_id(id)
          # TODO
        end

        def create(attributes)
          # TODO
        end
      end
    end
  end
end
