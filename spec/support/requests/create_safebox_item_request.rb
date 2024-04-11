# frozen_string_literal: true

module Test
  class CreateSafeboxItemRequest
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
