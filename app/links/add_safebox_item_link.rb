# frozen_string_literal: true

class AddSafeboxItemLink < BaseLink
  def self.build(id)
    {
      "href" => api_v1_safebox_safebox_items_url(id),
      "title" => "Add item to a safebox",
      "meta" => {
        "method" => "post"
      }
    }
  end
end
