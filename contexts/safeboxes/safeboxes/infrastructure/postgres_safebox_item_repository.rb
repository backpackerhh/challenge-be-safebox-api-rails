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
          safebox_item_record = SafeboxItemRecord.find(id)

          Domain::SafeboxItemEntity.from_primitives(
            id: safebox_item_record.id,
            name: safebox_item_record.name,
            safebox_id: safebox_item_record.safebox_id
          )
        rescue ActiveRecord::RecordNotFound
          raise Shared::Infrastructure::Errors::RecordNotFoundError, id
        end

        def create(attributes)
          SafeboxItemRecord.create!(attributes)
        rescue ActiveRecord::RecordNotUnique
          raise Shared::Infrastructure::Errors::DuplicatedRecordError, attributes[:id]
        rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
          raise Shared::Domain::Errors::InvalidArgumentError, e
        end

        def size
          SafeboxItemRecord.count
        end
      end
    end
  end
end
