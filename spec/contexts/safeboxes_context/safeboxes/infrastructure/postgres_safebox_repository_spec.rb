# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxesContext::Safeboxes::Infrastructure::PostgresSafeboxRepository, type: %i[repository database] do
  describe "#create(attributes)" do
    context "with errors" do
      it "raises an exception for a duplicated safebox" do
        repository = described_class.new
        safebox = SafeboxesContext::Safeboxes::Domain::NewSafeboxEntityFactory.create

        expect do
          repository.create(safebox.to_primitives)
        end.to raise_error(SharedContext::Infrastructure::Errors::DuplicatedRecordError)
      end

      it "raises an exception for a password too long" do
        repository = described_class.new
        attributes = SafeboxesContext::Safeboxes::Domain::NewSafeboxEntityFactory.attributes(
          password: SafeboxesContext::Safeboxes::Domain::SafeboxPasswordValueObjectFactory.too_long
        )

        expect do
          repository.create(attributes)
        end.to raise_error(SharedContext::Domain::Errors::InvalidArgumentError)
      end
    end

    context "without errors" do
      it "creates a new safebox" do
        repository = described_class.new
        safebox = SafeboxesContext::Safeboxes::Domain::NewSafeboxEntityFactory.build

        expect do
          repository.create(safebox.to_primitives)
        end.to(change { repository.size })
      end
    end
  end

  describe "#find_by_id(id)" do
    context "when safebox is not found" do
      it "raises an exception" do
        repository = described_class.new

        expect do
          repository.find_by_id(1)
        end.to raise_error(SharedContext::Infrastructure::Errors::RecordNotFoundError)
      end
    end

    context "when safebox is found" do
      it "returns the entity" do
        repository = described_class.new
        safebox = SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create

        found_safebox = repository.find_by_id(safebox.id.value)

        expect(found_safebox).to eq(safebox)
      end
    end
  end

  describe "#enable_opening_with_generated_token(id, password)" do
    context "when safebox is not found" do
      it "raises an exception" do
        repository = described_class.new

        expect do
          repository.find_by_id(1)
        end.to raise_error(SharedContext::Infrastructure::Errors::RecordNotFoundError)
      end
    end

    context "when password is not valid" do
      it "increments failed opening attempts" do
        repository = described_class.new
        safebox = SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(
          password: "secret",
          failed_opening_attempts: 0
        )

        repository.enable_opening_with_generated_token(safebox.id.value, "invalid")

        found_safebox = repository.find_by_id(safebox.id.value)

        expect(found_safebox.failed_opening_attempts.value).to eq(1)
      end

      it "returns nothing" do
        repository = described_class.new
        safebox = SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(
          password: "secret",
          failed_opening_attempts: 0
        )

        output = repository.enable_opening_with_generated_token(safebox.id.value, "invalid")

        expect(output).to be_nil
      end
    end

    context "when password is valid" do
      it "returns generated token" do
        repository = described_class.new
        safebox = SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(password: "secret")

        output = repository.enable_opening_with_generated_token(safebox.id.value, "secret")

        expect(output).to be_a(SafeboxesContext::Safeboxes::Domain::SafeboxTokenEntity)
      end
    end
  end

  describe "#valid_token?(token)" do
    it "returns false when token has expired" do
      repository = described_class.new
      safebox = SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(password: "secret")
      token = repository.enable_opening_with_generated_token(safebox.id.value, "secret")
      ttl = SafeboxesContext::Safeboxes::Infrastructure::SafeboxRecord::OPEN_TTL_IN_SECONDS

      travel_to (ttl + 1).seconds.from_now do
        result = repository.valid_token?(token.id.value)

        expect(result).to be false
      end
    end

    it "returns false when token is not valid" do
      repository = described_class.new

      result = repository.valid_token?("invalid")

      expect(result).to be false
    end

    it "returns true when token is valid" do
      repository = described_class.new
      safebox = SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.create(password: "secret")
      token = repository.enable_opening_with_generated_token(safebox.id.value, "secret")
      ttl = SafeboxesContext::Safeboxes::Infrastructure::SafeboxRecord::OPEN_TTL_IN_SECONDS

      travel_to ttl.seconds.from_now do
        result = repository.valid_token?(token.id.value)

        expect(result).to be true
      end
    end
  end
end
