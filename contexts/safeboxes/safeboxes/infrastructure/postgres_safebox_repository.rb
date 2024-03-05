# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class PostgresSafeboxRepository
        def create(attributes)
          SafeboxRecord.create!(attributes)
        rescue ActiveRecord::RecordNotUnique
          raise Shared::Infrastructure::Errors::DuplicatedRecordError, attributes[:id]
        rescue ActiveRecord::RecordInvalid => e
          raise Shared::Domain::Errors::InvalidArgumentError, e
        end

        def size
          SafeboxRecord.count
        end
      end
    end
  end
end
