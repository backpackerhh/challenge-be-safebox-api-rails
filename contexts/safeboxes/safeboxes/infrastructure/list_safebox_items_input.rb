# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class ListSafeboxItemsInput
        attr_reader :id, :token

        def initialize(id:, token:)
          @id = id
          @token = token
        end
      end
    end
  end
end
