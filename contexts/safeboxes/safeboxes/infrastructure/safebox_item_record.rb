# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxItemRecord < Shared::Infrastructure::ApplicationRecord
        self.table_name = "safeboxes_safebox_items"

        alias_attribute :safebox_id, :safeboxes_safeboxes_id
      end
    end
  end
end
