# frozen_string_literal: true

module Safeboxes
  module Safeboxes
    module Infrastructure
      class OpenSafeboxInput
        attr_reader :id, :password

        def initialize(id:, encoded_password:)
          @id = id
          @password = Base64.decode64(encoded_password.to_s)
        end
      end
    end
  end
end
