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
            password_digest { SafeboxPasswordDigestValueObjectFactory.build(password) }
            failed_opening_attempts { SafeboxFailedOpeningAttemptsValueObjectFactory.build(0) }

            trait :locked do
              failed_opening_attempts { SafeboxFailedOpeningAttemptsValueObjectFactory.locked }
            end
          end
        end

        def self.build_params(...)
          Infrastructure::CreateSafeboxRequest.build(attributes(...))
        end

        def self.attributes(...)
          FactoryBot.attributes_for(:safeboxes_safeboxes_safebox, ...)
        end

        def self.build(...)
          attributes = attributes(...)

          SafeboxEntity.from_primitives(**attributes)
        end

        def self.build_new(...)
          attributes = attributes(...)

          NewSafeboxEntity.from_primitives(**attributes)
        end

        def self.create(...)
          attributes = attributes(...)

          FactoryBot.create(:safeboxes_safeboxes_safebox, **attributes)

          NewSafeboxEntity.from_primitives(**attributes)
        end
      end
    end
  end
end
