# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_collection_attribute(attribute_name)
      HaveJsonApiCollectionAttributeMatcher.new(attribute_name)
    end

    class HaveJsonApiCollectionAttributeMatcher
      attr_reader :attribute_name

      def initialize(attribute_name)
        @attribute_name = attribute_name
      end

      def with_values(values)
        @expected_values = values

        self
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:data) &&
          other_hash[:data].all? { |r| r.key?(:attributes) && r[:attributes].key?(attribute_name) } &&
          (!defined?(@expected_values) ||
          other_hash[:data].pluck(:attributes).pluck(attribute_name) == @expected_values)
      end

      def failure_message
        message = "expected that #{@other_hash} would include attribute #{attribute_name} for each resource"
        message += " with values #{expectation}" if @expected_values
        message
      end

      def failure_message_when_negated
        message = "expected that #{@other_hash} would not include attribute #{attribute_name} for each resource"
        message += " with values #{expectation}" if @expected_values
        message
      end

      def description
        message = "have an attribute #{attribute_name} for each resource"
        message += " with expected values" if @expected_values
        message
      end

      private

      def expectation
        Array(@expected_values).map do |expected_value|
          { attributes: { attribute_name.to_sym => expected_value } }
        end
      end
    end
  end
end
