# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      module Links
        class ListSafeboxItemsLink < Shared::Infrastructure::LinkSerializer
          def self.build(safebox_id)
            {
              "href" => list_safebox_items_url(safebox_id),
              "title" => "Get all items from a safebox",
              "meta" => {
                "method" => "get"
              }
            }
          end
        end
      end
    end
  end
end
