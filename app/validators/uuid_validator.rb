# frozen_string_literal: true

class UuidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.to_s.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/)

    record.errors.add(attribute, options[:message] || "is not a valid UUID")
  end
end
