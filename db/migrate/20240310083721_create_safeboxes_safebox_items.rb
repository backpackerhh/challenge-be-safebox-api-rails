# frozen_string_literal: true

class CreateSafeboxesSafeboxItems < ActiveRecord::Migration[7.1]
  def change
    create_table :safeboxes_safebox_items, id: :uuid, default: nil do |t|
      t.string :name, null: false
      t.references :safeboxes_safeboxes, foreign_key: true, type: :uuid, null: false
      t.timestamps
    end
  end
end
