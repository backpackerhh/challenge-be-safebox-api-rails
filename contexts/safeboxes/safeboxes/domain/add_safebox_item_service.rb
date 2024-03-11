# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class AddSafeboxItemService < Shared::Domain::Service
        repository "safeboxes.safeboxes.safebox_item_repository", Domain::SafeboxItemRepository::Interface

        def add(data)
          safebox_item = Domain::SafeboxItemEntity.from_primitives(data)

          repository.create(safebox_item.to_primitives)
        end
      end
    end
  end
end
