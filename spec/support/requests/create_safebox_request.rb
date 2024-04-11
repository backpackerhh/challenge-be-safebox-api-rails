# frozen_string_literal: true

module Test
  class CreateSafeboxRequest
    def self.build(attributes)
      {
        data: {
          id: attributes.fetch(:id),
          type: "safebox",
          attributes: attributes.except(:id)
        }
      }
    end
  end
end
