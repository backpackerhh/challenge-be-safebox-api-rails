# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Application
      class ListSafeboxItemsUseCase < Shared::Application::UseCase
        repository "safeboxes.safeboxes.safebox_repository", Domain::SafeboxRepository::Interface
        result :safebox_items, :total_safebox_items

        def retrieve_all(input:)
          if input.invalid?
            return result.failure(input.errors)
          end

          safebox = repository.find_by_id(input.id)

          if safebox.locked?
            raise Domain::Errors::LockedSafeboxError, safebox.id.value
          end

          if !repository.valid_token?(input.token)
            raise Domain::Errors::InvalidSafeboxTokenError, safebox.id.value
          end

          data = safebox.items(input.query_params)

          result.success(safebox_items: data[:results], total_safebox_items: data[:total_results_count])
        end
      end
    end
  end
end
