# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class InMemorySafeboxRepository
        def create(_attributes); end

        def find_by_id(_id); end

        def enable_opening_with_generated_token(_id, _password); end

        def valid_token?(_token); end
      end
    end
  end
end
