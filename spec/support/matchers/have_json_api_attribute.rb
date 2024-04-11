# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_attribute(attribute_name)
      HaveJsonApiAttributeMatcher.new(attribute_name)
    end

    class HaveJsonApiAttributeMatcher
      attr_reader :attribute_name

      def initialize(attribute_name)
        @attribute_name = attribute_name
      end

      def with_value(value)
        @expected_value = value

        self
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:data) &&
          other_hash[:data].key?(:attributes) &&
          other_hash[:data][:attributes].key?(attribute_name) &&
          (!defined?(@expected_value) || other_hash[:data][:attributes][attribute_name] == @expected_value)
      end

      def failure_message
        "expected that #{@other_hash} would include #{expectation}"
      end

      def failure_message_when_negated
        "expected that #{@other_hash} would not include #{expectation}"
      end

      def description
        message = "have an attribute #{attribute_name}"
        message += " with expected value" if @expected_value
        message
      end

      private

      def expectation
        { data: { attributes: { attribute_name.to_sym => @expected_value || "[sample-value]" } } }
      end
    end
  end
end
