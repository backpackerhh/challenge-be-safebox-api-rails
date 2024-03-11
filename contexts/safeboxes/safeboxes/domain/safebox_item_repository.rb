# frozen_string_literal: true

require "dry-types"

module Safeboxes
  module Safeboxes
    module Domain
      module SafeboxItemRepository
        Interface = Dry.Types.Interface(:all, :find_by_id, :create)
      end
    end
  end
end
