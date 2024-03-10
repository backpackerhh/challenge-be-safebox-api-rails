# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxItemSerializer < Shared::Infrastructure::Serializer
        set_id :id do |safebox_item|
          safebox_item.id.value
        end

        attribute :name do |safebox_item|
          safebox_item.name.value
        end

        # NOTE: Uses a workaround defined in the entity to make this work properly
        belongs_to :safebox, serializer: SafeboxSerializer, id_method_name: :safebox_relationship_id
      end
    end
  end
end
