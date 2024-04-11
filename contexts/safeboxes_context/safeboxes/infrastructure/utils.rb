# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class Utils
        def self.generate_token(id, password)
          token = PostgresSafeboxRepository.new.enable_opening_with_generated_token(id, password)

          token.id.value
        end
      end
    end
  end
end
