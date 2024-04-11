# frozen_string_literal: true

class SafeboxItemCollectionSerializer < BaseSerializer
  set_type :safeboxItem

  attribute :name

  belongs_to :safebox, serializer: SafeboxSerializer
end
