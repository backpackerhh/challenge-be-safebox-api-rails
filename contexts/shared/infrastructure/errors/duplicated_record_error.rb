# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class DuplicatedRecordError < StandardError
        attr_reader :record_id, :record_type

        def initialize(record_id, record_type)
          super()
          @record_id = record_id
          @record_type = record_type
        end

        def message
          "Duplicated record"
        end

        def to_hash
          {
            title: message,
            detail: "#{record_type.capitalize} with ID #{record_id} already exists",
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
