# frozen_string_literal: true

module SafeboxesContext
  module Safeboxes
    module Domain
      class SafeboxItemNameValueObjectFactory
        def self.build(value = Faker::Name.name)
          value
        end
      end
    end
  end
end
