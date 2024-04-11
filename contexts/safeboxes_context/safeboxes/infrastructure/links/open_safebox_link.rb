# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      module Links
        class OpenSafeboxLink
          def self.build(url)
            {
              "href" => url,
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
