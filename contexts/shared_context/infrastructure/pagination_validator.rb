# frozen_string_literal: true

module SharedContext
  module Infrastructure
    class PaginationValidator
      DEFAULT_PAGE_NUMBER = 1
      DEFAULT_PAGE_SIZE = 10
      MAX_PAGE_SIZE = 25

      attr_reader :params

      def initialize(params)
        @params = params || {}
      end

      def valid?
        invalid_params.none? && invalid_values.none?
      end

      def errors
        param_errors = invalid_params.map do |invalid_param|
          Errors::InvalidPaginationParameterError.new(invalid_param)
        end
        value_errors = invalid_values.map do |invalid_param, invalid_value|
          Errors::InvalidPaginationValueError.new(invalid_param, invalid_value)
        end

        param_errors + value_errors
      end

      def query_params
        {
          number: params.fetch(:number, DEFAULT_PAGE_NUMBER).to_i,
          size: [params.fetch(:size, DEFAULT_PAGE_SIZE).to_i, MAX_PAGE_SIZE].min
        }
      end

      def invalid_params
        @invalid_params ||= params.keys - %i[number size]
      end

      def invalid_values
        @invalid_values ||= params.reject { |_param, value| value.to_i.positive? }
      end
    end
  end
end
