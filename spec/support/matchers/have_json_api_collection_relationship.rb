# frozen_string_literal: true

module Test
  module Matchers
    def have_json_api_collection_relationship(relationship_name)
      resource_hash_lambda = ->(resource, resource_type:) { resource_hash(resource, resource_type:) }

      HaveJsonApiCollectionRelationshipMatcher.new(relationship_name, resource_hash_lambda)
    end

    class HaveJsonApiCollectionRelationshipMatcher
      attr_reader :relationship_name, :resource_hash_lambda

      def initialize(relationship_name, resource_hash_lambda)
        @relationship_name = relationship_name
        @resource_hash_lambda = resource_hash_lambda
      end

      def with_resource(resource, resource_type: nil)
        @expected_value = { data: resource_hash_lambda.call(resource, resource_type:) }

        self
      end

      def with_resources(resources, resource_type: nil)
        @expected_value = {
          data: resources.map do |resource|
            resource_hash_lambda.call(resource, resource_type:)
          end
        }

        self
      end

      def without_resource
        @expected_value = { data: nil }

        self
      end

      def without_resources
        @expected_value = { data: [] }

        self
      end

      def matches?(other_hash)
        @other_hash = other_hash

        other_hash.key?(:data) &&
          other_hash[:data].all? { |r| r.key?(:relationships) && r[:relationships].key?(relationship_name) } &&
          (!defined?(@expected_value) ||
          other_hash[:data].pluck(:relationships).pluck(relationship_name).uniq == [@expected_value])
      end

      def failure_message
        message = "expected that #{@other_hash} would include relationship #{relationship_name} for each resource"
        message += " with value #{expectation}" if @expected_value
        message
      end

      def failure_message_when_negated
        message = "expected that #{@other_hash} would not include relationship #{relationship_name} for each resource"
        message += " with value #{expectation}" if @expected_value
        message
      end

      def description
        message = "have a relationship #{relationship_name} for each resource"
        message += " with expected value" if @expected_value
        message
      end

      private

      def expectation
        { data: [{ relationships: { relationship_name.to_sym => @expected_value || "[sample-value]" } }] }
      end
    end
  end
end
