# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :creator, factory: :user
    association :worker, factory: :user, strategy: :build

    trait :with_image do
      image { Rack::Test::UploadedFile.new('spec/assets/images/test_image.png', 'image/png') }
    end

    trait(:open) { status { :open } }
    trait(:accepted) { status { :accepted } }
    trait(:in_progress) { status { :in_progress } }
    trait(:rejected) { status { :rejected } }
    trait(:closed) { status { :closed } }

    trait(:low_priority) { priority { :low } }
    trait(:medium_priority) { priority { :medium } }
    trait(:high_priority) { priority { :high } }

    trait(:without_worker) { worker { nil } }
  end
end
