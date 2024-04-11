# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxTokenSerializer, type: :serializer do
  subject(:serializable_hash) do
    serializer = described_class.new(safebox_token, params: { id: safebox.id })

    serializer.serializable_hash
  end

  let(:safebox) { create(:safebox) }
  let(:safebox_token) { SafeboxToken.new(id: Test::Utils.generate_token(safebox.id)) }

  it { is_expected.to have_json_api_resource(safebox_token, resource_type: :safeboxToken) }

  it do
    expect(serializable_hash).to have_json_api_link(:self)
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
