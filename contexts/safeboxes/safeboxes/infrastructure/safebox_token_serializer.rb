# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxTokenSerializer < Shared::Infrastructure::Serializer
        set_id :id do |safebox|
          safebox.id.value
        end
      end
    end
  end
end
