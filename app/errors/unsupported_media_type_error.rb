# frozen_string_literal: true

class UnsupportedMediaTypeError < StandardError
  attr_reader :media_type, :header

  def initialize(media_type, header)
    super()
    @media_type = media_type.presence || "<empty>"
    @header = header
  end

  def message
    "Unsupported media type"
  end

  def to_hash
    {
      title: message,
      detail: "Unsupported media type: #{media_type}",
      status: "415",
      source: { header: }
    }
  end
end
