# frozen_string_literal: true

class OpenSafeboxLink < BaseLink
  def self.build(id)
    {
      "href" => open_api_v1_safebox_url(id),
      "title" => "Open a safebox",
      "meta" => {
        "method" => "post"
      }
    }
  end
end
