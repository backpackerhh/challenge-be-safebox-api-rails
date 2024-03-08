# frozen_string_literal: true

class AddFailedOpeningAttemptsToSafeboxesSafeboxes < ActiveRecord::Migration[7.1]
  def change
    add_column :safeboxes_safeboxes, :failed_opening_attempts, :integer, default: 0, null: false
  end
end
