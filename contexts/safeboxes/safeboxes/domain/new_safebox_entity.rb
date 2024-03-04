# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Domain
      class NewSafeboxEntity < Shared::Domain::AggregateRoot
        attr_reader :id, :name, :password

        def self.from_primitives(attributes)
          new(id: attributes.fetch(:id),
              name: attributes.fetch(:name),
              password: attributes.fetch(:password))
        end

        def initialize(id:, name:, password:)
          super()
          @id = SafeboxIdValueObject.new(value: id)
          @name = SafeboxNameValueObject.new(value: name)
          @password = SafeboxPasswordValueObject.new(value: password)
        end

        def to_primitives
          {
            id: id.value,
            name: name.value,
            password: password.value
          }
        end
      end
    end
  end
end
