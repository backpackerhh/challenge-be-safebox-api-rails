# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class SafeboxTokenSerializer < Shared::Infrastructure::Serializer
        set_id :id do |safebox_token|
          safebox_token.id.value
        end

        link :self do |_safebox_token, params|
          Links::OpenSafeboxLink.build(params[:safebox_id])
        end

        link :getItems do |_safebox_token, params|
          Links::ListSafeboxItemsLink.build(params[:safebox_id])
        end

        link :addItem do |_safebox_token, params|
          Links::AddSafeboxItemLink.build(params[:safebox_id])
        end
      end
    end
  end
end
