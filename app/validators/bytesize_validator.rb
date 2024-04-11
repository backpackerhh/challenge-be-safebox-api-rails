# frozen_string_literal: true

class BytesizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if options[:within].cover?(value.to_s.bytesize)

    record.errors.add(attribute, options[:message] || "is not within expected bytesize: #{options[:within]}")
  end
end
