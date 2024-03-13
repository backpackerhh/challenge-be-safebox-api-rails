# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class LoadSafeboxItemsService < Shared::Domain::Service
        repository "safeboxes.safeboxes.safebox_item_repository", Domain::SafeboxItemRepository::Interface

        def load(safebox_id:, params:)
          repository.all(safebox_id, params)
        end
      end
    end
  end
end
