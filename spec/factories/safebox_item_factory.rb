# frozen_string_literal: true

FactoryBot.define do
  factory :safebox_item do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    safebox
  end
end
