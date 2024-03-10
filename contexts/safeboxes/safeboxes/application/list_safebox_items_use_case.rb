# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Application
      class ListSafeboxItemsUseCase < Shared::Application::UseCase
        repository "safeboxes.safeboxes.safebox_repository", Domain::SafeboxRepository::Interface
        result :safebox_items

        def retrieve_all(input:)
          safebox = repository.find_by_id(input.id)

          if safebox.locked?
            raise Domain::Errors::LockedSafeboxError, safebox.id.value
          end

          if !repository.valid_token?(input.token)
            raise Domain::Errors::InvalidSafeboxTokenError, safebox.id.value
          end

          result.success(safebox_items: safebox.items)
        end
      end
    end
  end
end
