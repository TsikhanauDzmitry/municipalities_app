# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

return unless Rails.env.development?

users = [
  { email: 'admin@example.com', password: 'password', role: :admin },
  { email: 'employee1@example.com', password: 'password', role: :employee },
  { email: 'employee2@example.com', password: 'password', role: :employee },
  { email: 'employee3@example.com', password: 'password', role: :employee }
]

employees = []
users.each do |user_attrs|
  next if User.exists?(email: user_attrs[:email])

  user = User.find_or_create_by!(email: user_attrs[:email]) do |u|
    u.password = user_attrs[:password]
    u.role = user_attrs[:role]
  end

  Profile.create!(user:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)

  Address.create!(
    user:,
    country: Faker::Address.country,
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    zip_code: Faker::Address.zip_code
  )

  3.times do
    Issue.create!(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      status: :open,
      priority: %i[low medium high].sample,
      created_by: user.id
    )
  end

  employees << user if user_attrs[:role] == :employee
end

10.times do |i|
  resident = User.find_or_create_by!(email: "resident#{i + 1}@example.com") { |u| u.password = 'password' }

  Profile.create!(user: resident, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)

  Address.create!(
    user: resident,
    country: Faker::Address.country,
    city: Faker::Address.city,
    street: Faker::Address.street_name,
    zip_code: Faker::Address.zip_code
  )

  3.times do
    Issue.create!(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      status: %i[open accepted in_progress rejected closed].sample,
      priority: %i[low medium high].sample,
      worker_id: employees.sample[:id],
      created_by: resident.id
    ) do |issue|
      issue_image = URI.parse(Faker::LoremFlickr.image(size: '300x300', search_terms: %w[sports fitness])).open
      issue.image.attach(io: issue_image, filename: "#{issue_image}_faker.jpg", content_type: 'image/jpg')
    end
  end
end
