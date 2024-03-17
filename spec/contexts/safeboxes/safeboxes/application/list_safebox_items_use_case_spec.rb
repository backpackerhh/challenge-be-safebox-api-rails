# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safeboxes::Safeboxes::Application::ListSafeboxItemsUseCase, type: :use_case do
  describe "#retrieve_all(input:)" do
    let(:repository) { Safeboxes::Safeboxes::Infrastructure::InMemorySafeboxRepository.new }
    let(:id) { SecureRandom.uuid }
    let(:token) { "token" }
    let(:query_params) { { sort: "-createdAt" } }

    context "with an invalid input" do
      it "returns found errors" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput,
          invalid?: true,
          errors: ["<error>"]
        )

        result = described_class.new(repository:).retrieve_all(input:)

        expect(result.errors).to eq(["<error>"])
        expect(result.safebox_items).to be_nil
        expect(result.total_safebox_items).to be_nil
      end
    end

    context "with a locked safebox" do
      it "raises an exception" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput,
          invalid?: false,
          errors: [],
          id:
        )

        allow(repository).to receive(:find_by_id).with(id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(:locked, id:)
        end

        expect do
          described_class.new(repository:).retrieve_all(input:)
        end.to raise_error(Safeboxes::Safeboxes::Domain::Errors::LockedSafeboxError)
      end
    end

    context "when token is not valid" do
      it "raises an exception" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput,
          invalid?: false,
          errors: [],
          id:,
          token:
        )

        allow(repository).to receive(:find_by_id).with(id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id:)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(false)

        expect do
          described_class.new(repository:).retrieve_all(input:)
        end.to raise_error(Safeboxes::Safeboxes::Domain::Errors::InvalidSafeboxTokenError)
      end
    end

    context "when token is valid" do
      it "returns expected values" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::ListSafeboxItemsInput,
          invalid?: false,
          errors: [],
          id:,
          token:,
          query_params:
        )
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id:)
        safebox_items = [
          Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.build(safebox_id: safebox.id.value),
          Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.build(safebox_id: safebox.id.value)
        ]

        allow(repository).to receive(:find_by_id).with(id) do
          safebox
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        allow(safebox).to receive(:items).with(query_params) do
          { results: safebox_items, total_results_count: 2 }
        end

        result = described_class.new(repository:).retrieve_all(input:)

        expect(result.safebox_items).to eq(safebox_items)
        expect(result.total_safebox_items).to eq(2)
        expect(result.errors).to eq([])
      end
    end
  end
end
