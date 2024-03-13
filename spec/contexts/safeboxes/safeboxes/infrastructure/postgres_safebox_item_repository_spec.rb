# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safeboxes::Safeboxes::Infrastructure::PostgresSafeboxItemRepository, type: %i[repository database] do
  describe "#all(safebox_id, params)" do
    it "returns empty array without any items associated to given safebox" do
      repository = described_class.new

      result = repository.all("baa7a07f-d972-4cfe-88b5-248c87c51d78", {})

      expect(result).to eq([])
    end

    it "returns an entity for each item associated to given safebox" do
      repository = described_class.new
      safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
      safebox_item_a = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)
      safebox_item_b = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)

      result = repository.all(safebox.id.value, {})

      expect(result).to eq([safebox_item_a, safebox_item_b])
    end

    context "with sorting" do
      it "returns an entity for each item associated to given safebox sorted by creation date in descending order" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
        safebox_item_a = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)
        safebox_item_b = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)

        result = repository.all(safebox.id.value, sorting_params: { created_at: :desc })

        expect(result).to eq([safebox_item_b, safebox_item_a])
      end

      it "returns an entity for each item associated to given safebox sorted by name in ascending order" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
        safebox_item_a = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(
          safebox_id: safebox.id.value,
          name: "A"
        )
        safebox_item_b = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(
          safebox_id: safebox.id.value,
          name: "B"
        )

        result = repository.all(safebox.id.value, sorting_params: { name: :asc })

        expect(result).to eq([safebox_item_a, safebox_item_b])
      end
    end
  end

  describe "#find_by_id(id)" do
    context "when safebox item is not found" do
      it "raises an exception" do
        repository = described_class.new

        expect do
          repository.find_by_id(1)
        end.to raise_error(Shared::Infrastructure::Errors::RecordNotFoundError)
      end
    end

    context "when safebox item is found" do
      it "returns the entity" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
        safebox_item = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)

        found_safebox_item = repository.find_by_id(safebox_item.id.value)

        expect(found_safebox_item).to eq(safebox_item)
      end
    end
  end

  describe "#create(attributes)" do
    context "with errors" do
      it "raises an exception for a duplicated safebox item" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
        safebox_item = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.create(safebox_id: safebox.id.value)

        expect do
          repository.create(safebox_item.to_primitives)
        end.to raise_error(Shared::Infrastructure::Errors::DuplicatedRecordError)
      end

      it "raises an exception for an invalid argument" do
        repository = described_class.new
        attributes = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.attributes(id: "uuid")

        expect do
          repository.create(attributes)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end
    end

    context "without errors" do
      it "creates a new safebox item" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create
        safebox_item = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.build(safebox_id: safebox.id.value)

        expect do
          repository.create(safebox_item.to_primitives)
        end.to(change { repository.size })
      end
    end
  end
end
