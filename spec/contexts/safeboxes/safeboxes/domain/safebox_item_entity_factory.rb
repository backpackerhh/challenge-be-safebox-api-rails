# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxItemEntityFactory
        # @note These factory definitions are meant to be "private", but as they really aren't, the bounded context
        # and the module are included in the name of the factory to avoid name collisions with other factories
        FactoryBot.define do
          factory :safeboxes_safeboxes_safebox_item, class: "Safeboxes::Safeboxes::Infrastructure::SafeboxItemRecord" do
            id { SafeboxItemIdValueObjectFactory.build }
            name { SafeboxItemNameValueObjectFactory.build }
            safebox_id { SafeboxIdValueObjectFactory.build }
          end
        end

        def self.build(...)
          attributes = FactoryBot.attributes_for(:safeboxes_safeboxes_safebox_item, ...)

          SafeboxItemEntity.from_primitives(attributes)
        end

        def self.create(...)
          attributes = FactoryBot.attributes_for(:safeboxes_safeboxes_safebox_item, ...)

          FactoryBot.create(:safeboxes_safeboxes_safebox_item, attributes)

          SafeboxItemEntity.from_primitives(attributes)
        end
      end
    end
  end
end
