# frozen_string_literal: true

class BaseLink
  singleton_class.include Rails.application.routes.url_helpers
end
