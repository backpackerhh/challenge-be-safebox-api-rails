# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_collection_resource(resources, resource_type:)
      resource_hashes = resources.map { |resource| resource_hash(resource, resource_type:) }

      HaveJsonApiCollectionResourceMatcher.new(resource_hashes)
    end

    class HaveJsonApiCollectionResourceMatcher
      attr_reader :resource_hashes

      def initialize(resource_hashes)
        @resource_hashes = resource_hashes
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:data) &&
          other_hash[:data].pluck(:id) == resource_hashes.pluck(:id) &&
          other_hash[:data].pluck(:type) == resource_hashes.pluck(:type)
      end

      def failure_message
        "expected that #{@other_hash} would include #{expectation}"
      end

      def failure_message_when_negated
        "expected that #{@other_hash} would not include #{expectation}"
      end

      def description
        "have expected ID and type for each resource"
      end

      private

      def expectation
        { data: resource_hashes }
      end
    end
  end
end
