# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class PostgresSafeboxItemRepository
        def all(safebox_id, params)
          data = SharedContext::Infrastructure::ParametizableQuery.new.run(
            SafeboxItemRecord.where(safebox_id:),
            **params
          )
          entities = data[:results].map do |safebox_item|
            Domain::SafeboxItemEntity.from_primitives(
              id: safebox_item.id,
              name: safebox_item.name,
              safebox_id: safebox_item.safebox_id
            )
          end

          data.merge(results: entities)
        end

        def find_by_id(id)
          safebox_item_record = SafeboxItemRecord.find(id)

          Domain::SafeboxItemEntity.from_primitives(
            id: safebox_item_record.id,
            name: safebox_item_record.name,
            safebox_id: safebox_item_record.safebox_id
          )
        rescue ActiveRecord::RecordNotFound
          raise SharedContext::Infrastructure::Errors::RecordNotFoundError.new(id, "safebox item")
        end

        def create(attributes)
          SafeboxItemRecord.create!(attributes)
        rescue ActiveRecord::RecordNotUnique
          raise SharedContext::Infrastructure::Errors::DuplicatedRecordError.new(attributes[:id], "safebox item")
        rescue ActiveRecord::RecordInvalid, ActiveRecord::NotNullViolation => e
          raise SharedContext::Domain::Errors::InvalidArgumentError, e
        end

        def size
          SafeboxItemRecord.count
        end
      end
    end
  end
end
