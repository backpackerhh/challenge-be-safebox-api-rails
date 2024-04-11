# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Application
      class CreateSafeboxUseCase < SharedContext::Application::UseCase
        repository "safeboxes.safeboxes.safebox_repository", Domain::SafeboxRepository::Interface
        result :safebox

        def create(input:)
          if input.invalid?
            return result.failure(input.errors)
          end

          safebox = Domain::NewSafeboxEntity.from_primitives(input.data)

          repository.create(safebox.to_primitives)

          result.success(safebox:)
        end
      end
    end
  end
end
