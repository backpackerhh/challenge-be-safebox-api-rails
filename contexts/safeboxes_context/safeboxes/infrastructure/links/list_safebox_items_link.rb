# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      module Links
        class ListSafeboxItemsLink
          def self.build(url)
            {
              "href" => url,
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
