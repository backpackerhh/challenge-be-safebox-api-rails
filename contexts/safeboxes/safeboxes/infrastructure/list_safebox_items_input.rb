# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class ListSafeboxItemsInput < Shared::Infrastructure::CollectionInput
        sortable_by :name, :created_at

        attr_reader :id, :token

        def initialize(query_params:, id:, token:)
          super(query_params:)
          @id = id
          @token = token
        end
      end
    end
  end
end
