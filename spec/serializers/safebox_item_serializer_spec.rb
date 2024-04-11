# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxItemSerializer, type: :serializer do
  subject(:serializable_hash) do
    serializer = described_class.new(safebox_item, params: { id: safebox.id })

    serializer.serializable_hash
  end

  let(:safebox) { build(:safebox) }
  let(:safebox_item) { build(:safebox_item, safebox:) }

  it { is_expected.to have_json_api_resource(safebox_item, resource_type: :safeboxItem) }

  it do
    expect(serializable_hash).to have_json_api_relationship(:safebox)
      .with_resource(safebox)
  end

  it do
    expect(serializable_hash).to have_json_api_link(:self)
      .with_value(AddSafeboxItemLink.build(safebox.id))
  end

  it do
    expect(serializable_hash).to have_json_api_link(:getItems)
      .with_value(ListSafeboxItemsLink.build(safebox.id))
  end
end
