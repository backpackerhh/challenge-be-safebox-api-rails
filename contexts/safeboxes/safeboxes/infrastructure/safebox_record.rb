# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxRecord < Shared::Infrastructure::ApplicationRecord
        self.table_name = "safeboxes_safeboxes"

        has_secure_password
      end
    end
  end
end
