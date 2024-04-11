# frozen_string_literal: true

class Safebox < ApplicationRecord
  OPEN_TTL_IN_SECONDS = 180 # 3 minutes
  MAX_FAILED_ATTEMPTS_BEFORE_LOCKING = 3
  NAME_MIN_LENGTH = 3
  NAME_MAX_LENGTH = 50
  PASSWORD_MIN_BYTESIZE = 6
  PASSWORD_MAX_BYTESIZE = 72

  self.table_name = "safeboxes_safeboxes"

  has_secure_password

  generates_token_for :open, expires_in: OPEN_TTL_IN_SECONDS

  has_many :items,
           class_name: "SafeboxItem",
           foreign_key: :safeboxes_safeboxes_id,
           inverse_of: :safebox,
           dependent: :destroy

  validates :id,
            presence: true,
            uuid: true,
            uniqueness: { case_sensitive: false }
  validates :name,
            presence: true,
            length: { within: NAME_MIN_LENGTH..NAME_MAX_LENGTH }
  validates :password,
            presence: true,
            bytesize: { within: PASSWORD_MIN_BYTESIZE..PASSWORD_MAX_BYTESIZE }
  validates :failed_opening_attempts,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: MAX_FAILED_ATTEMPTS_BEFORE_LOCKING
            }

  def locked?
    failed_opening_attempts == MAX_FAILED_ATTEMPTS_BEFORE_LOCKING
  end

  def valid_token?(token)
    safebox = Safebox.find_by_token_for(:open, token)

    !safebox.nil?
  end
end
