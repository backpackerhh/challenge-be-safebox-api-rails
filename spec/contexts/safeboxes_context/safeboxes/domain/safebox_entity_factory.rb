# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      class SafeboxEntityFactory
        # @note These factory definitions are meant to be "private", but as they really aren't, the bounded context
        # and the module are included in the name of the factory to avoid name collisions with other factories
        FactoryBot.define do
          factory :safeboxes_safeboxes_safebox, class: "SafeboxesContext::Safeboxes::Infrastructure::SafeboxRecord" do
            id { SafeboxIdValueObjectFactory.build }
            name { SafeboxNameValueObjectFactory.build }
            password { SafeboxPasswordValueObjectFactory.build }
            failed_opening_attempts { SafeboxFailedOpeningAttemptsValueObjectFactory.build(0) }

            trait :locked do
              failed_opening_attempts { SafeboxFailedOpeningAttemptsValueObjectFactory.locked }
            end
          end
        end

        def self.build(...)
          safebox_record = FactoryBot.build(:safeboxes_safeboxes_safebox, ...)
          attributes = safebox_record.attributes.transform_keys(&:to_sym)

          SafeboxEntity.from_primitives(attributes)
        end

        def self.create(...)
          safebox_record = FactoryBot.create(:safeboxes_safeboxes_safebox, ...)
          attributes = safebox_record.attributes.transform_keys(&:to_sym)

          SafeboxEntity.from_primitives(attributes)
        end
      end
    end
  end
end
