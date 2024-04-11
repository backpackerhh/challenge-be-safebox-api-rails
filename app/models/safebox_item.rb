# frozen_string_literal: true

class SafeboxItem < ApplicationRecord
  self.table_name = "safeboxes_safebox_items"

  alias_attribute :safebox_id, :safeboxes_safeboxes_id

  belongs_to :safebox, inverse_of: :items, foreign_key: :safeboxes_safeboxes_id

  validates :id, presence: true, uuid: true, uniqueness: true
  validates :safebox_id, presence: true, uuid: true
  validates :name, presence: true
end
