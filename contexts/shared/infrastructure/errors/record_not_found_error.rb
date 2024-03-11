# frozen_string_literal: true

module Shared
  module Infrastructure
    module Errors
      class RecordNotFoundError < StandardError
        attr_reader :record_id, :record_type

        def initialize(record_id, record_type)
          super()
          @record_id = record_id
          @record_type = record_type
        end

        def message
          "Record not found"
        end

        def to_hash
          {
            title: message,
            detail: "#{record_type.capitalize} with ID #{record_id} does not exist",
            status: "404"
          }
        end
      end
    end
  end
end
