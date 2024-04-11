# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      module Links
        class CreateSafeboxLink
          def self.build(url)
            {
              "href" => url,
              "title" => "Create a new safebox",
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
