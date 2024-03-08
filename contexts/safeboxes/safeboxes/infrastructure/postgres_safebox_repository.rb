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

        def find_by_id(_id)
          # TODO
        end

        def enable_opening_with_generated_token(_id, _password)
          # TODO
        end
      end
    end
  end
end
