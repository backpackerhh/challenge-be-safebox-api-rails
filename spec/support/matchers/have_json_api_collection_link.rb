# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_collection_link
      HaveJsonApiCollectionLinkMatcher.new
    end

    class HaveJsonApiCollectionLinkMatcher
      def with_value(value)
        @expected_value = value

        self
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:links) &&
          (!defined?(@expected_value) || other_hash[:links] == @expected_value)
      end

      def failure_message
        "expected that #{@other_hash} would include #{expectation}"
      end

      def failure_message_when_negated
        "expected that #{@other_hash} would not include #{expectation}"
      end

      def description
        message = "have links"
        message += " with expected value" if @expected_value
        message
      end

      private

      def expectation
        { links: @expected_value || "[sample-value]" }
      end
    end
  end
end
