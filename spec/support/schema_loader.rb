# frozen_string_literal: true

module Test
  module SchemaLoader
    def self.load_schema(schema_name)
      schema_file = File.expand_path("schemas/#{schema_name}_schema.json", __dir__)
      content = File.read(schema_file)

      JSON.parse(content)
    end
  end
end
