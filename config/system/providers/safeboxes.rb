# frozen_string_literal: true

SafeIsh::Container.register_provider :safeboxes, namespace: true do
  start do
    register "safeboxes.safebox_repository",
             SafeboxesContext::Safeboxes::Infrastructure::PostgresSafeboxRepository.new
    register "safeboxes.safebox_item_repository",
             SafeboxesContext::Safeboxes::Infrastructure::PostgresSafeboxItemRepository.new
  end
end
