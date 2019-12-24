# frozen_string_literal: true

FactoryBot.define do
  factory :season do
    with_year

    start_date { Date.new(year, 2, 15) }
    end_date { Date.new(year, 11, 20) }

    trait :now do
      start_date { Date.today - 40.days }
      end_date { Date.today + 40.days }
    end
  end
end
