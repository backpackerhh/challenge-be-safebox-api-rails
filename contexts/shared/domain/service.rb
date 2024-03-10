# frozen_string_literal: true

require "dry-struct"

module Shared
  module Domain
    class Service < Dry::Struct
      transform_keys(&:to_sym)

      # @see https://github.com/dry-rb/dry-struct/blob/release-1.6/lib/dry/struct/class_interface.rb#L249
      def self.new(*)
        super
      rescue Dry::Struct::Error => e
        raise Errors::InvalidArgumentError, e
      end

      def self.repository(dependency_key, type)
        attribute :repository, type # order matters here

        include SafeIsh::Deps[repository: dependency_key]
      end
    end
  end
end
