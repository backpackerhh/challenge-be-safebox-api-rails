# frozen_string_literal: true

module SharedContext
  module Infrastructure
    class Error
      attr_reader :title, :detail, :status, :code, :source, :meta

      def self.generate_from(errors)
        Array(errors).flat_map { |error| new(**error) }
      end

      def initialize(title:, detail: nil, status: nil, code: nil, source: {}, meta: {})
        @title = title
        @detail = detail
        @status = status
        @code = code
        @source = source
        @meta = meta
      end

      def to_hash
        {
          title:,
          detail:,
          status:,
          code:,
          source:,
          meta:
        }.compact_blank!
      end
    end
  end
end
