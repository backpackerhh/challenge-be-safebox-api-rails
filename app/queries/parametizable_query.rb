# frozen_string_literal: true

class ParametizableQuery
  # @note Not particularly worrying here but consider adding some kind of cache to avoid
  # calculating the total results count for every page
  def run(relation, pagination_params:, sorting_params: {})
    query_wrapper = ParametizableQueryWrapper.new(relation)
    total_results_count = query_wrapper.count
    results = query_wrapper.sort(sorting_params).paginate(pagination_params).relation

    { total_results_count:, results: }
  end
end
