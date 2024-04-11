# frozen_string_literal: true

class SafeboxTokenSerializer < BaseSerializer
  link :self do |_safebox_token, params|
    OpenSafeboxLink.build(params.fetch(:id))
  end

  link :getItems do |_safebox_token, params|
    ListSafeboxItemsLink.build(params.fetch(:id))
  end

  link :addItem do |_safebox_token, params|
    AddSafeboxItemLink.build(params.fetch(:id))
  end
end
