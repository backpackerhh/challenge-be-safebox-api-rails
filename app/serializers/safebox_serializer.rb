# frozen_string_literal: true

class SafeboxSerializer < BaseSerializer
  attribute :name

  link :self do
    CreateSafeboxLink.build
  end

  link :open do |safebox|
    OpenSafeboxLink.build(safebox.id)
  end

  link :getItems do |safebox|
    ListSafeboxItemsLink.build(safebox.id)
  end

  link :addItem do |safebox|
    AddSafeboxItemLink.build(safebox.id)
  end
end
