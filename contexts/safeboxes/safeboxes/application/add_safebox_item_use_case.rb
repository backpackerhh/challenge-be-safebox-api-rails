# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Application
      class AddSafeboxItemUseCase < Shared::Application::UseCase
        repository "safeboxes.safeboxes.safebox_repository", Domain::SafeboxRepository::Interface
        result :safebox_item

        def create(input:)
          safebox = repository.find_by_id(input.safebox_id)

          if safebox.locked?
            raise Domain::Errors::LockedSafeboxError, safebox.id.value
          end

          if !repository.valid_token?(input.token)
            raise Domain::Errors::InvalidSafeboxTokenError, safebox.id.value
          end

          if input.invalid?
            return result.failure(input.errors)
          end

          safebox.add_item(input.data)

          result.success(safebox_item: safebox.item(input.data.fetch(:id)))
        end
      end
    end
  end
end
