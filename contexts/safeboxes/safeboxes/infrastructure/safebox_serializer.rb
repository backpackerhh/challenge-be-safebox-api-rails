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

        link :self do
          Links::CreateSafeboxLink.build
        end

        link :open do |safebox|
          Links::OpenSafeboxLink.build(safebox.id.value)
        end

        link :getItems do |safebox|
          Links::ListSafeboxItemsLink.build(safebox.id.value)
        end

        link :addItem do |safebox|
          Links::AddSafeboxItemLink.build(safebox.id.value)
        end
      end
    end
  end
end
