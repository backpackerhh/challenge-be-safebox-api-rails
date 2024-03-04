# frozen_string_literal: true

require "dry-struct"

module Shared
  module Application
    class UseCase < Dry::Struct
      transform_keys(&:to_sym)

      def self.result_class
        @result_class ||= Result.with_members(:empty)
      end

      def self.result(*)
        @result_class = Result.with_members(*)
      end

      # @see https://github.com/dry-rb/dry-struct/blob/release-1.6/lib/dry/struct/class_interface.rb#L249
      def self.new(*)
        super
      rescue Dry::Struct::Error => e
        raise InvalidDependencyInjectedError, e
      end

      def self.repository(dependency_key, type)
        attribute :repository, type # order matters here

        include SafeIsh::Deps[repository: dependency_key]
      end

      def initialize(*)
        super

        return if respond_to?(:repository)

        raise NotImplementedError,
              "Define the repository interface for the use case with .repository class method"
      end

      def result
        self.class.result_class
      end

      class Result < Struct
        def self.with_members(*)
          new(*, :errors, keyword_init: true)
        end

        def self.success(*)
          new(*)
        end

        def self.failure(errors)
          new(errors:)
        end

        def initialize(*args)
          super(*args)
          self.errors ||= []
        end

        def on_success
          yield(*values) if errors.none?
          self
        end

        def on_failure
          yield(errors) if errors.any?
          self
        end
      end
    end
  end
end
