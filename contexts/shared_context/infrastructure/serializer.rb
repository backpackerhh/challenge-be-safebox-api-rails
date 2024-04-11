# frozen_string_literal: true

require "jsonapi/serializer"

module SharedContext
  module Infrastructure
    class Serializer
      include JSONAPI::Serializer

      set_key_transform :camel_lower
    end
  end
end
