# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxRecord < Shared::Infrastructure::ApplicationRecord
        OPEN_TTL_IN_SECONDS = 180 # 3 minutes

        self.table_name = "safeboxes_safeboxes"

        has_secure_password

        generates_token_for :open, expires_in: OPEN_TTL_IN_SECONDS
      end
    end
  end
end
