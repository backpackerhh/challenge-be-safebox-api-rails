# frozen_string_literal: true

require "spec_helper"

RSpec.describe SafeboxToken do
  it "has expected attributes" do
    expect(described_class.instance_methods(false)).to eq([:id])
  end
end
