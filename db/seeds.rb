# frozen_string_literal: true

exit unless Rails.env.development?

User.create! email: 'admin@example.com', password: 'Password1', password_confirmation: 'Password1', admin: true,
             first_name: Faker::Name.first_name, last_name: Faker::Name.last_name

users = Array.new(10) do
  password = Faker::Internet.password(min_length: 8)
  User.create! email: Faker::Internet.unique.email,
               password:, password_confirmation: password,
               first_name: Faker::Name.first_name, last_name: Faker::Name.last_name
end

Season.create! available: 2.years.ago, start_date: 1.year.ago, end_date: 1.year.from_now

15.times do
  start_date = Faker::Date.between(from: 6.months.ago, to: 6.months.from_now)
  end_date = start_date + [0, 0, 0, 0, 0, 1, 2, 3, 4, 7].sample.days
  Event.create! start_date:, end_date:, user: users.sample
end

3.times do
  date = Faker::Date.between(from: 6.months.ago, to: 6.months.from_now)
  Event.create! start_date: date, end_date: date, title: Faker::Lorem.sentence(word_count: 3), user: nil
end
