# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      module Links
        class ListSafeboxItemsCollectionLinks
          def self.build(urls, query_params, total_count)
            {
              "self" => ListSafeboxItemsLink.build(urls.fetch(:self_url)),
              "addItem" => AddSafeboxItemLink.build(urls.fetch(:add_item_url)),
              **SharedContext::Infrastructure::PaginationLinks.build(
                url_lambda: urls.fetch(:self_url_lambda),
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
