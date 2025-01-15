# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }

    trait(:admin) do
      role { :admin }
    end

    trait(:resident) do
      role { :resident }
    end

    trait(:employee) do
      role { :employee }
    end
  end
end
