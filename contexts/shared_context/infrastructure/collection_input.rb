# frozen_string_literal: true

module SharedContext
  module Infrastructure
    class CollectionInput
      def self.sortable_fields
        @sortable_fields || []
      end

      def self.sortable_by(*args)
        @sortable_fields = args
      end

      attr_reader :sorting_validator, :pagination_validator

      def initialize(query_params:)
        @sorting_validator = SortingValidator.new(query_params[:sort], self.class.sortable_fields)
        @pagination_validator = PaginationValidator.new(query_params[:page])
      end

      def valid?
        [sorting_validator.valid?, pagination_validator.valid?].reduce(:&)
      end

      def invalid?
        !valid?
      end

      def errors
        [sorting_validator.errors, pagination_validator.errors].reduce(:+)
      end

      def query_params
        {
          sorting_params: sorting_validator.query_params,
          pagination_params: pagination_validator.query_params
        }
      end
    end
  end
end
