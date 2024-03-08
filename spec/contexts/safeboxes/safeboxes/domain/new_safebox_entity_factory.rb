# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class NewSafeboxEntityFactory
        # @note These factory definitions are meant to be "private", but as they really aren't, the bounded context
        # and the module are included in the name of the factory to avoid name collisions with other factories
        FactoryBot.define do
          factory :safeboxes_safeboxes_new_safebox, class: "Safeboxes::Safeboxes::Infrastructure::SafeboxRecord" do
            id { SafeboxIdValueObjectFactory.build }
            name { SafeboxNameValueObjectFactory.build }
            password { SafeboxPasswordValueObjectFactory.build }
          end
        end

        def self.build_params(...)
          Infrastructure::CreateSafeboxRequest.build(attributes(...))
        end

        def self.attributes(...)
          FactoryBot.attributes_for(:safeboxes_safeboxes_new_safebox, ...)
        end

        def self.build(...)
          attributes = attributes(...)

          NewSafeboxEntity.from_primitives(**attributes)
        end

        def self.create(...)
          attributes = attributes(...)

          FactoryBot.create(:safeboxes_safeboxes_new_safebox, **attributes)

          NewSafeboxEntity.from_primitives(**attributes)
        end
      end
    end
  end
end
