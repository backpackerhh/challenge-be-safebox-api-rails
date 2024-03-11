# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safeboxes::Safeboxes::Application::CreateSafeboxUseCase, type: :use_case do
  describe "#create(input:)" do
    let(:repository) { Safeboxes::Safeboxes::Infrastructure::InMemorySafeboxRepository.new }
    let(:attributes) do
      {
        id: "93711b5b-0f08-49d9-b819-322d83801d09",
        name: "Safebox 01",
        password: "1234567890"
      }
    end

    context "with valid attributes" do
      it "creates safebox" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes
        )

        expect(repository).to receive(:create).with(
          {
            id: "93711b5b-0f08-49d9-b819-322d83801d09",
            name: "Safebox 01",
            password: "1234567890"
          }
        )

        described_class.new(repository:).create(input:)
      end

      it "returns safebox" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes
        )

        result = described_class.new(repository:).create(input:)

        expect(result.safebox).to be_a(Safeboxes::Safeboxes::Domain::NewSafeboxEntity)
      end

      it "returns empty errors" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes
        )

        result = described_class.new(repository:).create(input:)

        expect(result.errors).to eq([])
      end
    end

    context "with invalid attributes" do
      it "does not return any safebox" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: true,
          errors: ["<error>"],
          data: attributes
        )

        result = described_class.new(repository:).create(input:)

        expect(result.safebox).to be_nil
      end

      it "returns found errors" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: true,
          errors: ["<error>"],
          data: attributes
        )

        result = described_class.new(repository:).create(input:)

        expect(result.errors).to eq(["<error>"])
      end

      it "does not create safebox (invalid ID)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(id: "uuid")
        )

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end

      it "does not create safebox (name too short)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(name: Safeboxes::Safeboxes::Domain::SafeboxNameValueObjectFactory.too_short)
        )

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end

      it "does not create safebox (name too long)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(name: Safeboxes::Safeboxes::Domain::SafeboxNameValueObjectFactory.too_long)
        )

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end

      it "does not create safebox (password bytesize too short)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(password: Safeboxes::Safeboxes::Domain::SafeboxPasswordValueObjectFactory.too_short)
        )

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end

      it "does not create safebox (password bytesize too long)" do
        input = instance_double(
          Safeboxes::Safeboxes::Infrastructure::CreateSafeboxInput,
          invalid?: false,
          errors: [],
          data: attributes.merge(password: Safeboxes::Safeboxes::Domain::SafeboxPasswordValueObjectFactory.too_long)
        )

        expect do
          described_class.new(repository:).create(input:)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end
    end
  end
end
