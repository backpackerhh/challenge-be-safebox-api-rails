# frozen_string_literal: true

class SafeboxItemSerializer < BaseSerializer
  attribute :name

  belongs_to :safebox, serializer: SafeboxSerializer

  link :self do |_safebox_item, params|
    AddSafeboxItemLink.build(params.fetch(:id))
  end

  link :getItems do |_safebox_item, params|
    ListSafeboxItemsLink.build(params.fetch(:id))
  end
end
