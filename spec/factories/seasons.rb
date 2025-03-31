# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    with_year

    start_date { Date.new(year, 1, 1) }
    end_date { Date.new(year, 12, 31) }
    available { start_date }

    trait :now do
      start_date { 40.days.ago.to_date }
      end_date { 40.days.from_now.to_date }
    end
  end
end
