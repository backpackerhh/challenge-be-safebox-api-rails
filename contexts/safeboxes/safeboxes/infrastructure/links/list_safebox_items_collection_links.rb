# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      module Links
        class ListSafeboxItemsCollectionLinks < Shared::Infrastructure::LinkSerializer
          def self.build(safebox_id, query_params, total_count)
            {
              "self" => ListSafeboxItemsLink.build(safebox_id),
              "addItem" => AddSafeboxItemLink.build(safebox_id),
              **Shared::Infrastructure::PaginationLinks.build(
                url_callback: ->(params) { list_safebox_items_url(safebox_id, params) },
                query_params:,
                total_count:
              )
            }
          end
        end
      end
    end
  end
end
