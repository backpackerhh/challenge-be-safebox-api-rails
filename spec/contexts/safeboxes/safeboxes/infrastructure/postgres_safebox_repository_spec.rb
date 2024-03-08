# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safeboxes::Safeboxes::Infrastructure::PostgresSafeboxRepository, type: %i[repository database] do
  describe "#create(attributes)" do
    context "with errors" do
      it "raises an exception for a duplicated safebox" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.create

        expect do
          repository.create(safebox.to_primitives)
        end.to raise_error(Shared::Infrastructure::Errors::DuplicatedRecordError)
      end

      it "raises an exception for a password too long" do
        repository = described_class.new
        attributes = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.attributes(
          password: Safeboxes::Safeboxes::Domain::SafeboxPasswordValueObjectFactory.too_long
        )

        expect do
          repository.create(attributes)
        end.to raise_error(Shared::Domain::Errors::InvalidArgumentError)
      end
    end

    context "without errors" do
      it "creates a new safebox" do
        repository = described_class.new
        safebox = Safeboxes::Safeboxes::Domain::SafeboxEntityFactory.build_new

        expect do
          repository.create(safebox.to_primitives)
        end.to(change { repository.size })
      end
    end
  end
end
