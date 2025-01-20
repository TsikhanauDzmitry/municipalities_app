# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }

    trait(:admin) { role { :admin } }
    trait(:resident) { role { :resident } }
    trait(:employee) { role { :employee } }
  end
end
