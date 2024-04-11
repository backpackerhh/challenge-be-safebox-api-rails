# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Application
      class AddSafeboxItemUseCase < SharedContext::Application::UseCase
        repository "safeboxes.safeboxes.safebox_repository", Domain::SafeboxRepository::Interface
        result :safebox_item
        logger

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

          logger.info("Item successfully added to safebox with ID #{safebox.id.value}")

          result.success(safebox_item: safebox.item(input.data.fetch(:id)))
        end
      end
    end
  end
end
