# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safeboxes::Safeboxes::Application::AddSafeboxItemUseCase, type: :use_case do
  describe "#create(input:)" do
    let(:repository) { Safeboxes::Safeboxes::Infrastructure::InMemorySafeboxRepository.new }
    let(:safebox_id) { "f626c808-648c-41fe-865d-c6062f3e0899" }
    let(:token) { "token" }
    let(:attributes) do
      {
        id: "93711b5b-0f08-49d9-b819-322d83801d09",
        name: "Item 01",
        safebox_id:
      }
    end

    context "with a locked safebox" do
      it "raises an exception" do
        input = instance_double(Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput, safebox_id:)

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(:locked, id: safebox_id)
        end

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Safeboxes::Safeboxes::Domain::Errors::LockedSafeboxError)
      end
    end

    context "with an invalid token" do
      it "raises an exception" do
        input = instance_double(Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput, safebox_id:, token:)

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(false)

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Safeboxes::Safeboxes::Domain::Errors::InvalidSafeboxTokenError)
      end
    end

    context "with invalid attributes" do
      it "does not return any safebox item" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: true,
          errors: ["<error>"],
          data: attributes,
          safebox_id:,
          token:
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        result = described_class.new(repository:).create(input:)

        expect(result.safebox_item).to be_nil
      end

      it "returns found errors" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: true,
          errors: ["<error>"],
          data: attributes,
          safebox_id:,
          token:
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        result = described_class.new(repository:).create(input:)

        expect(result.errors).to eq(["<error>"])
      end

      it "does not create safebox item (invalid ID)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(id: "uuid"),
          safebox_id:,
          token:
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end

      it "does not create safebox item (invalid name)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(name: nil),
          safebox_id:,
          token:
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end

      it "does not create safebox item (invalid safebox ID)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(safebox_id: "uuid"),
          safebox_id:,
          token:
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end
    end

    context "with valid attributes" do
      it "adds new item to the safebox" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: false,
          errors: [],
          data: attributes,
          safebox_id:,
          token:
        )
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        safebox_item = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.build(
          id: input.data[:id],
          safebox_id: safebox.id.value
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          safebox
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        allow(safebox).to receive(:item).with(safebox_item.id.value)

        expect(safebox).to receive(:add_item).with(input.data)

        described_class.new(repository:).create(input:)
      end

      it "returns safebox" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: false,
          errors: [],
          data: attributes,
          safebox_id:,
          token:
        )
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        safebox_item = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.build(
          id: input.data[:id],
          safebox_id: safebox.id.value
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          safebox
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        allow(safebox).to receive(:add_item).with(input.data)

        allow(safebox).to receive(:item).with(safebox_item.id.value) do
          safebox_item
        end

        result = described_class.new(repository:).create(input:)

        expect(result.safebox_item).to be_a(Safeboxes::Safeboxes::Domain::SafeboxItemEntity)
      end

      it "returns empty errors" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::AddSafeboxItemInput,
          invalid?: false,
          errors: [],
          data: attributes,
          safebox_id:,
          token:
        )
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build(id: safebox_id)
        safebox_item = Safeboxes::Safeboxes::Domain::SafeboxItemEntityFactory.build(
          id: input.data[:id],
          safebox_id: safebox.id.value
        )

        allow(repository).to receive(:find_by_id).with(safebox_id) do
          safebox
        end

        allow(repository).to receive(:valid_token?).with(token).and_return(true)

        allow(safebox).to receive(:add_item).with(input.data)

        allow(safebox).to receive(:item).with(safebox_item.id.value) do
          safebox_item
        end

        result = described_class.new(repository:).create(input:)

        expect(result.errors).to eq([])
      end
    end
  end
end
