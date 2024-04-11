# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_resource(resource, resource_type: nil, resource_id: nil)
      resource_hash = resource_hash(resource, resource_type:, resource_id:)

      HaveJsonApiResourceMatcher.new(resource_hash)
    end

    class HaveJsonApiResourceMatcher
      attr_reader :resource_hash

      def initialize(resource_hash)
        @resource_hash = resource_hash
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:data) &&
          other_hash[:data][:id] == resource_hash[:id] &&
          other_hash[:data][:type] == resource_hash[:type]
      end

      def failure_message
        "expected that #{@other_hash} would include #{expectation}"
      end

      def failure_message_when_negated
        "expected that #{@other_hash} would not include #{expectation}"
      end

      def description
        "have expected ID and type"
      end

      private

      def expectation
        { data: resource_hash }
      end
    end
  end
end
