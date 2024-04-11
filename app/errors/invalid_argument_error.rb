# frozen_string_literal: true

class InvalidArgumentError < StandardError
  attr_reader :original_error

  def self.generate_from(errors)
    Array(errors).flat_map { |error| new(error) }
  end

  def initialize(original_error)
    super()
    @original_error = original_error
  end

  def message
    "Invalid argument error"
  end

  def to_hash
    {
      title: message,
      detail: original_error.full_message,
      status: "422",
      source: {
        pointer:
      }
    }
  end

  private

  def pointer
    if original_error.attribute == :id
      "/data/id"
    else
      "/data/attributes/#{original_error.attribute}"
    end
  end
end
