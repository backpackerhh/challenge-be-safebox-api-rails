# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxEntityFactory
        # @note These factory definitions are meant to be "private", but as they really aren't, the bounded context
        # and the module are included in the name of the factory to avoid name collisions with other factories
        FactoryBot.define do
          factory :safeboxes_safeboxes_safebox, class: "Safeboxes::Safeboxes::Infrastructure::SafeboxRecord" do
            id { SafeboxIdValueObjectFactory.build }
            name { SafeboxNameValueObjectFactory.build }
            password { SafeboxPasswordValueObjectFactory.build }
          end
        end

        def self.build_params(...)
          attributes = FactoryBot.attributes_for(:safeboxes_safeboxes_safebox, ...)

          Infrastructure::CreateSafeboxRequest.build(attributes)
        end
      end
    end
  end
end
