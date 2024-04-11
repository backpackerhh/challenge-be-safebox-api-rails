# frozen_string_literal: true

module Test
  module Matchers
    def resource_hash(resource, resource_type: nil, resource_id: nil)
      {
        type: resource_type || resource.class.name.demodulize.camelize(:lower).to_sym,
        id: resource_id || resource.id.to_s
      }
    end
  end
end
