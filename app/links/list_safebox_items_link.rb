# frozen_string_literal: true

class ListSafeboxItemsLink < BaseLink
  def self.build(id)
    {
      "href" => api_v1_safebox_safebox_items_url(id),
      "title" => "Get all items from a safebox",
      "meta" => {
        "method" => "get"
      }
    }
  end
end
