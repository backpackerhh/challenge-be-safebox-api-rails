# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_link(link_name)
      HaveJsonApiLinkMatcher.new(link_name)
    end

    class HaveJsonApiLinkMatcher
      attr_reader :link_name

      def initialize(link_name)
        @link_name = link_name
      end

      def with_value(value)
        @expected_value = value

        self
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:data) &&
          other_hash[:data].key?(:links) &&
          other_hash[:data][:links].key?(link_name) &&
          (!defined?(@expected_value) || other_hash[:data][:links][link_name] == @expected_value)
      end

      def failure_message
        "expected that #{@other_hash} would include #{expectation}"
      end

      def failure_message_when_negated
        "expected that #{@other_hash} would not include #{expectation}"
      end

      def description
        message = "have a link #{link_name}"
        message += " with expected value" if @expected_value
        message
      end

      private

      def expectation
        { data: { links: { link_name.to_sym => @expected_value || "[sample-value]" } } }
      end
    end
  end
end
