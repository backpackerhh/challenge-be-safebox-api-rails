# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Infrastructure
      class PostgresSafeboxRepository
        def create(attributes)
          SafeboxRecord.create!(attributes)
        rescue ActiveRecord::RecordNotUnique
          raise SharedContext::Infrastructure::Errors::DuplicatedRecordError.new(attributes[:id], "safebox")
        rescue ActiveRecord::RecordInvalid => e
          raise SharedContext::Domain::Errors::InvalidArgumentError, e
        end

        def size
          SafeboxRecord.count
        end

        def find_by_id(id)
          safebox_record = find_record_by_id(id)

          Domain::SafeboxEntity.from_primitives(safebox_record.attributes.transform_keys(&:to_sym))
        end

        def enable_opening_with_generated_token(id, password)
          safebox_record = find_record_by_id(id)

          if !safebox_record.authenticate_password(password)
            safebox_record.increment!(:failed_opening_attempts)

            return
          end

          Domain::SafeboxTokenEntity.from_primitives(id: safebox_record.generate_token_for(:open))
        end

        def valid_token?(token)
          safebox_record = SafeboxRecord.find_by_token_for(:open, token)

          !safebox_record.nil?
        end

        private

        def find_record_by_id(id)
          SafeboxRecord.find(id)
        rescue ActiveRecord::RecordNotFound
          raise SharedContext::Infrastructure::Errors::RecordNotFoundError.new(id, "safebox")
        end
      end
    end
  end
end
