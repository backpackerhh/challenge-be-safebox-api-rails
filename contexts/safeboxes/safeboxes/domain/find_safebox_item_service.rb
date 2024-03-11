# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class FindSafeboxItemService < Shared::Domain::Service
        repository "safeboxes.safeboxes.safebox_item_repository", Domain::SafeboxItemRepository::Interface

        def find(id)
          repository.find_by_id(id)
        end
      end
    end
  end
end
