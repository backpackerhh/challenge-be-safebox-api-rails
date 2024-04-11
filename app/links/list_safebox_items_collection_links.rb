# frozen_string_literal: true

class ListSafeboxItemsCollectionLinks < BaseLink
  def self.build(id, query_params, total_count)
    {
      "self" => ListSafeboxItemsLink.build(id),
      "addItem" => AddSafeboxItemLink.build(id),
      **PaginationLinks.build(
        url_lambda: ->(params) { api_v1_safebox_safebox_items_url(id, params) },
        query_params:,
        total_count:
      )
    }
  end
end
