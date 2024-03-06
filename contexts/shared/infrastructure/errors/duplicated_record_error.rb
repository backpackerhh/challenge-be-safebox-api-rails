# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class DuplicatedRecordError < StandardError
        attr_reader :id

        def initialize(id)
          super()
          @id = id
        end

        def message
          "Duplicated record"
        end

        def to_hash
          {
            title: message,
            detail: "Record with ID #{id} already exists",
            status: "409",
            source: {
              pointer: "/data/id"
            }
          }
        end
      end
    end
  end
end
