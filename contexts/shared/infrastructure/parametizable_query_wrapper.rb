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
    end
  end
end
