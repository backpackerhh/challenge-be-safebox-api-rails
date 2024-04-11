# frozen_string_literal: true

module SharedContext
  module Infrastructure
    class LinkSerializer
      singleton_class.include Rails.application.routes.url_helpers
    end
  end
end
