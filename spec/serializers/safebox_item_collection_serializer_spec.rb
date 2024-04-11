# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxItemCollectionSerializer, type: :serializer do
  subject(:serializable_hash) do
    serializer = described_class.new(
      safebox_items,
      is_collection: true,
      links: ListSafeboxItemsCollectionLinks.build(safebox.id, {}, safebox_items.size)
    )

    serializer.serializable_hash
  end

  let(:safebox) { build(:safebox) }
  let(:safebox_items) { [build(:safebox_item, safebox:), build(:safebox_item, safebox:)] }

  it do
    expect(serializable_hash).to have_json_api_collection_resource(safebox_items, resource_type: :safeboxItem)
  end

  it do
    expect(serializable_hash).to have_json_api_collection_attribute(:name).with_values(safebox_items.pluck(:name))
  end

  it do
    expect(serializable_hash).to have_json_api_collection_relationship(:safebox).with_resource(safebox)
  end

  it do
    expect(serializable_hash).to have_json_api_collection_link
      .with_value(ListSafeboxItemsCollectionLinks.build(safebox.id, {}, 2))
  end
end
