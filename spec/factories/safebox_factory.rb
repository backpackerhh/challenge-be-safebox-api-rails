# frozen_string_literal: true

FactoryBot.define do
  factory :safebox do
    id { SecureRandom.uuid }
    name { Faker::Name.name }
    password { Faker::Internet.password }
    failed_opening_attempts { 0 }

    trait :locked do
      failed_opening_attempts { Safebox::MAX_FAILED_ATTEMPTS_BEFORE_LOCKING }
    end
  end
end
