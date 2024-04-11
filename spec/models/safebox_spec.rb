# frozen_string_literal: true

require "rails_helper"

RSpec.describe Safebox, type: :model do
  it "is associated to expected DB table" do
    expect(described_class.table_name).to eq("safeboxes_safeboxes")
  end

  describe "associations" do
    it do
      safebox = build(:safebox)

      expect(safebox).to have_many(:items).class_name("SafeboxItem")
                                          .dependent(:destroy)
                                          .with_foreign_key(:safeboxes_safeboxes_id)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:id) }

    it do
      safebox = build(:safebox)

      expect(safebox).to validate_uniqueness_of(:id).case_insensitive
    end

    it "is expected not to be valid when :id is not a valid UUID" do
      safebox = build(:safebox, id: "uuid")

      safebox.valid?

      expect(safebox.errors[:id]).to eq(["can't be blank", "is not a valid UUID"])
    end

    it "is expected to be valid when :id is a valid UUID" do
      safebox = build(:safebox, id: SecureRandom.uuid)

      safebox.valid?

      expect(safebox.errors[:id]).to eq([])
    end

    it { is_expected.to validate_presence_of(:name) }

    it do
      safebox = build(:safebox)

      expect(safebox).to validate_length_of(:name).is_at_least(described_class::NAME_MIN_LENGTH)
                                                  .is_at_most(described_class::NAME_MAX_LENGTH)
    end

    it { is_expected.to validate_presence_of(:password) }

    it "is expected not to be valid when :password bytesize is too short" do
      safebox = build(:safebox, password: SecureRandom.alphanumeric(described_class::PASSWORD_MIN_BYTESIZE - 1))

      safebox.valid?

      expect(safebox.errors[:password]).to eq(["is not within expected bytesize: 6..72"])
    end

    it "is expected not to be valid when :password bytesize is too long" do
      safebox = build(:safebox, password: SecureRandom.alphanumeric(described_class::PASSWORD_MAX_BYTESIZE + 1))

      safebox.valid?

      expect(safebox.errors[:password]).to eq(["is too long", "is not within expected bytesize: 6..72"])
    end

    it "is expected to be valid when :password bytesize is valid" do
      safebox = build(:safebox, password: SecureRandom.alphanumeric(described_class::PASSWORD_MAX_BYTESIZE))

      safebox.valid?

      expect(safebox.errors[:password]).to eq([])
    end
  end

  describe "#locked?" do
    it "returns false when failed opening attempts is less " \
       "than #{described_class::MAX_FAILED_ATTEMPTS_BEFORE_LOCKING}" do
      safebox = described_class.new(failed_opening_attempts: described_class::MAX_FAILED_ATTEMPTS_BEFORE_LOCKING - 1)

      expect(safebox).not_to be_locked
    end

    it "returns true when failed opening attempts is #{described_class::MAX_FAILED_ATTEMPTS_BEFORE_LOCKING}" do
      safebox = described_class.new(failed_opening_attempts: described_class::MAX_FAILED_ATTEMPTS_BEFORE_LOCKING)

      expect(safebox).to be_locked
    end
  end

  describe "#valid_token?(token)" do
    it "returns false when given token does not exist" do
      safebox = build(:safebox)

      expect(safebox).not_to be_valid_token("invalid token")
    end

    it "returns false when given token is expired" do
      safebox = create(:safebox)
      token = safebox.generate_token_for(:open)

      travel_to (described_class::OPEN_TTL_IN_SECONDS + 1).seconds.from_now do
        expect(safebox).not_to be_valid_token(token)
      end
    end

    it "returns true when given token is valid" do
      safebox = create(:safebox)
      token = safebox.generate_token_for(:open)

      travel_to described_class::OPEN_TTL_IN_SECONDS.seconds.from_now do
        expect(safebox).to be_valid_token(token)
      end
    end
  end
end
