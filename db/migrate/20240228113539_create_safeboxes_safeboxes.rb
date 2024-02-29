# frozen_string_literal: true

class CreateSafeboxesSafeboxes < ActiveRecord::Migration[7.1]
  def change
    create_table :safeboxes_safeboxes, id: false do |t|
      t.uuid :id, primary_key: true, null: false
      t.string :name, null: false, limit: 50
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
