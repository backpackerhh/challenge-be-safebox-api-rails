# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class CreateSafeboxInput < Shared::Infrastructure::DataInput
        def data
          {
            id: raw_data.dig("data", "id"),
            name: raw_data.dig("data", "attributes", "name"),
            password: raw_data.dig("data", "attributes", "password")
          }
        end

        private

        def schema_name
          "new_safebox"
        end
      end
    end
  end
end
