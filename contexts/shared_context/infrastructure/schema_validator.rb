# frozen_string_literal: true

require "json-schema"

module SharedContext
  module Infrastructure
    module SchemaValidator
      def self.validate(schema_name, data)
        JSON::Validator.fully_validate(load_schema(schema_name), data, errors_as_objects: true)
      end

      def self.load_schema(schema_name)
        schema_file = File.expand_path("schemas/#{schema_name}_schema.json", __dir__)
        content = File.read(schema_file)

        JSON.parse(content)
      end
    end
  end
end
