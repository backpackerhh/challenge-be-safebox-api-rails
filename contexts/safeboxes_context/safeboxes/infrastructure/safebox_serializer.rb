# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class SafeboxSerializer < SharedContext::Infrastructure::Serializer
        set_id :id do |safebox|
          safebox.id.value
        end

        attribute :name do |safebox|
          safebox.name.value
        end

        link :self do |_safebox, params|
          Links::CreateSafeboxLink.build(params.fetch(:self_url))
        end

        link :open do |_safebox, params|
          Links::OpenSafeboxLink.build(params.fetch(:open_url))
        end

        link :getItems do |_safebox, params|
          Links::ListSafeboxItemsLink.build(params.fetch(:get_items_url))
        end

        link :addItem do |_safebox, params|
          Links::AddSafeboxItemLink.build(params.fetch(:add_item_url))
        end
      end
    end
  end
end
