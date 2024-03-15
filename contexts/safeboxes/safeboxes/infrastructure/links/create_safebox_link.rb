# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      module Links
        class CreateSafeboxLink < Shared::Infrastructure::LinkSerializer
          def self.build
            {
              "href" => create_safebox_url,
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
