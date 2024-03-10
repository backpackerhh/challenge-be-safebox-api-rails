# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class SafeboxEntity < Shared::Domain::AggregateRoot
        attr_reader :id, :name, :password_digest, :failed_opening_attempts

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              name: attributes.fetch(:name),
              password_digest: attributes.fetch(:password_digest),
              failed_opening_attempts: attributes.fetch(:failed_opening_attempts))
        end

        def initialize(id:, name:, password_digest:, failed_opening_attempts:)
          super()
          @id = SafeboxIdValueObject.new(value: id)
          @name = SafeboxNameValueObject.new(value: name)
          @password_digest = SafeboxPasswordDigestValueObject.new(value: password_digest)
          @failed_opening_attempts = SafeboxFailedOpeningAttemptsValueObject.new(value: failed_opening_attempts)
        end

        def locked?
          failed_opening_attempts.value == SafeboxFailedOpeningAttemptsValueObject::MAX_ATTEMPTS_BEFORE_LOCKING
        end

        def items(domain_service = LoadSafeboxItemsService.new)
          domain_service.load(safebox_id: id.value) # Lazy loaded
        end

        def to_primitives
          {
            id: id.value,
            name: name.value,
            failed_opening_attempts: failed_opening_attempts.value
          }
        end
      end
    end
  end
end
