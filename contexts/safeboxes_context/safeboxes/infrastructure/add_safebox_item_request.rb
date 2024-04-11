# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class AddSafeboxItemRequest
        def self.build(attributes)
          {
            data: {
              id: attributes.fetch(:id),
              type: "safeboxItem",
              attributes: attributes.slice(:name),
              relationships: {
                safebox: {
                  data: {
                    id: attributes.fetch(:safebox_id),
                    type: "safebox"
                  }
                }
              }
            }
          }
        end
      end
    end
  end
end
