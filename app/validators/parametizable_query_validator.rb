# frozen_string_literal: true

class ParametizableQueryValidator
  attr_reader :sorting_validator, :pagination_validator

  def initialize(query_params, sortable_by: [])
    @sorting_validator = QueryParams::SortingValidator.new(query_params[:sort], sortable_by)
    @pagination_validator = QueryParams::PaginationValidator.new(query_params[:page])
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
