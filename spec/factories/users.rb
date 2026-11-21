# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(name: first_name) }
    password { 'Password123' }
    password_confirmation { 'Password123' }
    admin { false }

    trait :invited do
      encrypted_password { 'x' }

      transient do
        inviter { association :user }
      end

      to_create do |user, evaluator|
        user.skip_invitation = true
        user.invite! evaluator.inviter
      end
    end

    trait :oauth do
      encrypted_password { 'x' }
      provider { 'test' }
      uid { 'user@test.local' }
    end
  end
end
