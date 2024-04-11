# frozen_string_literal: true

require "rails_helper"

RSpec.describe SafeboxesContext::Safeboxes::Application::OpenSafeboxUseCase, type: :use_case do
  describe "#open(input:)" do
    let(:repository) { SafeboxesContext::Safeboxes::Infrastructure::InMemorySafeboxRepository.new }
    let(:id) { SecureRandom.uuid }
    let(:password) { "encoded-password" }
    let(:input) { instance_double(SafeboxesContext::Safeboxes::Infrastructure::OpenSafeboxInput, id:, password:) }

    context "with a locked safebox" do
      it "raises an exception" do
        allow(repository).to receive(:find_by_id).with(id) do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.build(:locked, id:)
        end

        expect do
          described_class.new(repository:).open(input:)
        end.to raise_error(SafeboxesContext::Safeboxes::Domain::Errors::LockedSafeboxError)
      end
    end

    context "when password is not valid" do
      it "raises an exception" do
        allow(repository).to receive(:find_by_id).with(id) do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.build(id:)
        end

        allow(repository).to receive(:enable_opening_with_generated_token).with(id, password).and_return(nil)

        expect do
          described_class.new(repository:).open(input:)
        end.to raise_error(SafeboxesContext::Safeboxes::Domain::Errors::InvalidSafeboxPasswordError)
      end
    end

    context "when password is valid" do
      it "returns generated token" do
        allow(repository).to receive(:find_by_id).with(id) do
          SafeboxesContext::Safeboxes::Domain::SafeboxEntityFactory.build(id:)
        end

        allow(repository).to receive(:enable_opening_with_generated_token).with(id, password).and_return("token")

        result = described_class.new(repository:).open(input:)

        expect(result.safebox_token).to eq("token")
      end
    end
  end
end
