# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxSerializer, type: :serializer do
  subject(:serializable_hash) do
    serializer = described_class.new(safebox)

    serializer.serializable_hash
  end

  let(:safebox) { build(:safebox) }

  it { is_expected.to have_json_api_resource(safebox, resource_type: :safebox) }

  it { is_expected.to have_json_api_attribute(:name).with_value(safebox.name) }

  it do
    expect(serializable_hash).to have_json_api_link(:self)
      .with_value(CreateSafeboxLink.build)
  end

  it do
    expect(serializable_hash).to have_json_api_link(:open)
      .with_value(OpenSafeboxLink.build(safebox.id))
  end

  it do
    expect(serializable_hash).to have_json_api_link(:getItems)
      .with_value(ListSafeboxItemsLink.build(safebox.id))
  end

  it do
    expect(serializable_hash).to have_json_api_link(:addItem)
      .with_value(AddSafeboxItemLink.build(safebox.id))
  end
end
