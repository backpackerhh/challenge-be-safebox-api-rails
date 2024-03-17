# frozen_string_literal: true

module Shared
  module Infrastructure
    class ParametizableQueryWrapper
      attr_reader :relation

      def initialize(relation)
        @relation = relation
      end

      def sort(sorting_params)
        @relation = @relation.order(sorting_params)

        self
      end

      def paginate(pagination_params)
        page_number = pagination_params.fetch(:number)
        page_size = pagination_params.fetch(:size)

        @relation = @relation.offset((page_number - 1) * page_size).limit(page_size)

        self
      end

      # @note This solution won't work for grouped results, so some adaptation would be necessary
      def count
        @relation.count(:all)
      end
    end
  end
end
