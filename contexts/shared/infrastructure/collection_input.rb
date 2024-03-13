# frozen_string_literal: true

module Shared
  module Infrastructure
    class CollectionInput
      def self.sortable_fields
        @sortable_fields || []
      end

      def self.sortable_by(*args)
        @sortable_fields = args
      end

      attr_reader :sorting_validator

      def initialize(query_params:)
        @sorting_validator = SortingValidator.new(query_params[:sort], self.class.sortable_fields)
      end

      def valid?
        [sorting_validator.valid?].reduce(:&)
      end

      def invalid?
        !valid?
      end

      def errors
        [sorting_validator.errors].reduce(:+)
      end

      def query_params
        {
          sorting_params: sorting_validator.query_params
        }
      end
    end
  end
end
