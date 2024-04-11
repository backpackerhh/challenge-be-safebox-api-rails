# frozen_string_literal: true

module QueryParams
  class SortingValidator
    attr_reader :params, :allowed_fields

    def initialize(params, allowed_fields)
      @params = params.to_s
                      .gsub("::", "/")
                      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                      .downcase
      @allowed_fields = allowed_fields.map(&:to_s)
    end

    def valid?
      invalid_fields.none?
    end

    def errors
      invalid_fields.map do |invalid_field|
        InvalidSortingParameterError.new(invalid_field)
      end
    end

    def query_params
      @query_params ||= params.split(",").each_with_object({}) do |field, memo|
        if field.to_s.start_with?("-")
          dir = :desc
          field = field[1..]
        else
          dir = :asc
        end

        memo[field] = dir
      end
    end

    def invalid_fields
      @invalid_fields ||= query_params.keys - allowed_fields
    end
  end
end
