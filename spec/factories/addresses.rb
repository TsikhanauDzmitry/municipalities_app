# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    country { Faker::Address.country }
    city { Faker::Address.city }
    street { Faker::Address.street_name }
    zip_code { Faker::Address.zip_code }
    user { association(:user) }
  end
end
