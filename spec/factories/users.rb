# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(first_name) }
    password { 'Password123' }
    password_confirmation { 'Password123' }
    admin { false }

    trait :invited do
      encrypted_password { 'x' }

      after(:create) do |user|
        user.invite! do |u|
          u.skip_invitation = true
        end
      end
    end

    trait :oauth do
      encrypted_password { 'x' }
      provider { 'test' }
      uid { 'user@test.local' }
    end
  end
end
