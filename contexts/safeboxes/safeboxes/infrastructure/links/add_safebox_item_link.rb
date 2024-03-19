# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      module Links
        class AddSafeboxItemLink
          def self.build(url)
            {
              "href" => url,
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
