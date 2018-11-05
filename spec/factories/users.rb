# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(first_name) }
    password 'Password123'
    password_confirmation 'Password123'
    admin false

    trait :invited do
      password nil
      password_confirmation nil
      invitation_token '***'
    end

    trait :oauth do
      password nil
      password_confirmation nil
      provider 'test'
      uid 'test@example.com'
    end
  end
end
