# frozen_string_literal: true

class CreateSafeboxLink < BaseLink
  def self.build
    {
      "href" => api_v1_safeboxes_url,
      "title" => "Create a new safebox",
      "meta" => {
        "method" => "post"
      }
    }
  end
end
