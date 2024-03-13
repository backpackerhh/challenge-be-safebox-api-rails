# frozen_string_literal: true

module Shared
  module Infrastructure
    class ParametizableQuery
      def run(relation, sorting_params: {})
        result = ParametizableQueryWrapper.new(relation).sort(sorting_params)

        result.relation
      end
    end
  end
end
