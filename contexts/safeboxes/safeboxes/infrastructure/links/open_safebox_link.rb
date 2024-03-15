# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      module Links
        class OpenSafeboxLink < Shared::Infrastructure::LinkSerializer
          def self.build(id)
            {
              "href" => open_safebox_url(id),
              "title" => "Open a safebox",
              "meta" => {
                "method" => "post"
              }
            }
          end
        end
      end
    end
  end
end
