# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class InMemorySafeboxItemRepository
        def all(_safebox_id); end

        def find_by_id(_id); end

        def create(_attributes); end
      end
    end
  end
end
