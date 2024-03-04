# frozen_string_literal: true

SafeIsh::Container.register_provider :safeboxes, namespace: true do
  start do
    register "safeboxes.safebox_repository", Safeboxes::Safeboxes::Infrastructure::PostgresSafeboxRepository.new
  end
end
