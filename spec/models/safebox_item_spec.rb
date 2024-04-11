# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxItem, type: :model do
  it "is associated to expected DB table" do
    expect(described_class.table_name).to eq("safeboxes_safebox_items")
  end

  describe "associations" do
    it do
      safebox_item = build(:safebox_item)

      expect(safebox_item).to belong_to(:safebox).with_foreign_key(:safeboxes_safeboxes_id)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:id) }

    it do
      safebox_item = build(:safebox_item)

      expect(safebox_item).to validate_uniqueness_of(:id).case_insensitive
    end

    it "is expected not to be valid when :id is not a valid UUID" do
      safebox_item = build(:safebox_item, id: "uuid")

      safebox_item.valid?

      expect(safebox_item.errors[:id]).to eq(["can't be blank", "is not a valid UUID"])
    end

    it "is expected to be valid when :id is a valid UUID" do
      safebox_item = build(:safebox_item, id: SecureRandom.uuid)

      safebox_item.valid?

      expect(safebox_item.errors[:id]).to eq([])
    end

    it { is_expected.to validate_presence_of(:safebox_id) }

    it "is expected not to be valid when :safebox_id is not a valid UUID" do
      safebox_item = build(:safebox_item, safebox_id: "uuid")

      safebox_item.valid?

      expect(safebox_item.errors[:safebox_id]).to eq(["can't be blank", "is not a valid UUID"])
    end

    it "is expected to be valid when :safebox_id is a valid UUID" do
      safebox_item = build(:safebox_item, safebox_id: SecureRandom.uuid)

      safebox_item.valid?

      expect(safebox_item.errors[:safebox_id]).to eq([])
    end

    it { is_expected.to validate_presence_of(:name) }
  end
end
