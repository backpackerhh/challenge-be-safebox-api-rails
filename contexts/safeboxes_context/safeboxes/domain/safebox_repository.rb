# frozen_string_literal: true

require "dry-types"

module SafeboxesContext
  module Safeboxes
    module Domain
      module SafeboxRepository
        Interface = Dry.Types.Interface(:create, :find_by_id, :enable_opening_with_generated_token)
      end
    end
  end
end
