# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.last_name }
    user { association(:user) }
  end
end
