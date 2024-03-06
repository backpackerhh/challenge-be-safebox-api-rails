# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxSerializer < Shared::Infrastructure::Serializer
        set_id :id do |safebox|
          safebox.id.value
        end

        attribute :name do |safebox|
          safebox.name.value
        end
      end
    end
  end
end
