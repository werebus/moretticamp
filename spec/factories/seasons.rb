# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    with_year

    start_date { Date.new(year, 1, 1) }
    end_date { Date.new(year, 12, 31) }

    trait :now do
      start_date { Date.today - 40.days }
      end_date { Date.today + 40.days }
    end
  end
end
