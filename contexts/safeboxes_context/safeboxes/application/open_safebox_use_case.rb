# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Application
      class OpenSafeboxUseCase < SharedContext::Application::UseCase
        repository "safeboxes.safeboxes.safebox_repository", Domain::SafeboxRepository::Interface
        result :safebox_token
        logger

        def open(input:)
          safebox = repository.find_by_id(input.id)

          if safebox.locked?
            raise Domain::Errors::LockedSafeboxError, safebox.id.value
          end

          safebox_token = repository.enable_opening_with_generated_token(safebox.id.value, input.password)

          if safebox_token.nil?
            raise Domain::Errors::InvalidSafeboxPasswordError, safebox.id.value
          end

          logger.info("Safebox with ID #{safebox.id.value} successfully open")

          result.success(safebox_token:)
        end
      end
    end
  end
end
