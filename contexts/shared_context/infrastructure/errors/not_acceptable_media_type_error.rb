# frozen_string_literal: true

module SharedContext
  module Infrastructure
    module Errors
      class NotAcceptableMediaTypeError < StandardError
        attr_reader :media_type, :header

        def initialize(media_type, header)
          super()
          @media_type = media_type.presence || "<empty>"
          @header = header
        end

        def message
          "Not acceptable media type"
        end

        def to_hash
          {
            title: message,
            detail: "Not acceptable media type: #{media_type}",
            status: "406",
            source: { header: }
          }
        end
      end
    end
  end
end
