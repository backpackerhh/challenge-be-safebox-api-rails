# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      module Links
        class AddSafeboxItemLink < Shared::Infrastructure::LinkSerializer
          def self.build(safebox_id)
            {
              "href" => add_safebox_item_url(safebox_id),
              "title" => "Add item to a safebox",
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
