# frozen_string_literal: true

Dry::Rails.container do
  # All features disabled because it assumes ApplicationController exists in app/controllers
  #
  # @see https://github.com/dry-rb/dry-rails/blob/main/lib/dry/rails/boot/safe_params.rb
  config.features = []

  # Make classes auto-registered and exposed via application container
  # config.component_dirs.add "contexts"

  # Custom providers
  config.provider_dirs << "config/system/providers"
end
