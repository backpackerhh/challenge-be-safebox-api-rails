# frozen_string_literal: true

SafeIsh::Container.register_provider :app, namespace: true do
  start do
    register "logger", Rails.logger
  end
end
