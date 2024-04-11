# frozen_string_literal: true

module SharedContext
  module Infrastructure
    class DataInput
      attr_reader :raw_data

      def initialize(raw_data:)
        @raw_data = raw_data
      end

      def valid?
        errors.empty?
      end

      def invalid?
        !valid?
      end

      def errors
        validation_errors = SchemaValidator.validate(schema_name, raw_data)

        validation_errors.map { |error| Errors::SchemaValidationError.new(error) }
      end

      private

      def schema_name
        raise NotImplementedError
      end
    end
  end
end
