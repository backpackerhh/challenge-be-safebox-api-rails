# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safeboxes::Safeboxes::Infrastructure::PostgresSafeboxItemRepository, type: %i[repository database] do
  describe "#all(safebox_id)" do
    it "returns empty array without any safebox items for given safebox" do
      repository = described_class.new

      result = repository.all("baa7a07f-d972-4cfe-88b5-248c87c51d78")

      expect(result).to eq([])
    end

    it "returns an entity for each safebox item associated to given safebox" do
      repository = described_class.new
      safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
      safebox_item_a = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)
      safebox_item_b = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)

      result = repository.all(safebox.id.value)

      expect(result).to eq([safebox_item_a, safebox_item_b])
    end
  end
end
