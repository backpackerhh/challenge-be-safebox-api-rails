# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class AddSafeboxItemInput < SharedContext::Infrastructure::DataInput
        attr_reader :safebox_id, :token

        def initialize(raw_data:, safebox_id:, token:)
          super(raw_data:)
          @safebox_id = safebox_id
          @token = token
        end

        def data
          {
            id: raw_data.dig("data", "id"),
            name: raw_data.dig("data", "attributes", "name"),
            safebox_id: raw_data.dig("data", "relationships", "safebox", "data", "id")
          }
        end

        private

        def schema_name
          "new_safebox_item"
        end
      end
    end
  end
end
