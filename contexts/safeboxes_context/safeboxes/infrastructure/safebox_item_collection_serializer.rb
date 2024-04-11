# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class SafeboxItemCollectionSerializer < SharedContext::Infrastructure::Serializer
        set_id :id do |safebox_item|
          safebox_item.id.value
        end

        set_type :safeboxItem

        attribute :name do |safebox_item|
          safebox_item.name.value
        end

        # @note Uses a workaround defined in the entity to make this work properly
        belongs_to :safebox, serializer: SafeboxSerializer, id_method_name: :safebox_relationship_id
      end
    end
  end
end
