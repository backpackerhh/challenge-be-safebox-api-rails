# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class RecordNotFoundError < StandardError
        attr_reader :id

        def initialize(id)
          super()
          @id = id
        end

        def message
          "Record not found"
        end

        def to_hash
          {
            title: message,
            detail: "Record with ID #{id} does not exist",
            status: "404"
          }
        end
      end
    end
  end
end
