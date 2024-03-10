# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class LoadSafeboxItemsService < Shared::Domain::Service
        repository "safeboxes.safeboxes.safebox_item_repository", Domain::SafeboxItemRepository::Interface

        def load(safebox_id:)
          repository.all(safebox_id)
        end
      end
    end
  end
end
