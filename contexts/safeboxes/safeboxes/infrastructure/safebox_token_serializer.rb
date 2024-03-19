# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxTokenSerializer < Shared::Infrastructure::Serializer
        set_id :id do |safebox_token|
          safebox_token.id.value
        end

        link :self do |_safebox_token, params|
          Links::OpenSafeboxLink.build(params.fetch(:self_url))
        end

        link :getItems do |_safebox_token, params|
          Links::ListSafeboxItemsLink.build(params.fetch(:get_items_url))
        end

        link :addItem do |_safebox_token, params|
          Links::AddSafeboxItemLink.build(params.fetch(:add_item_url))
        end
      end
    end
  end
end
