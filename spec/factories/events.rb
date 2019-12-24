# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    with_year
    user

    start_date { Date.new(year, rand(6..8), rand(1..30)) }
    end_date do
      if start_date.present?
        weights = { 0 => 7, 1 => 4, 2 => 3, 4 => 1, 5 => 1,
                    6 => 1, 7 => 1, 8 => 1, 10 => 1 }
        duration = weights.map { |d, w| [d] * w }.flatten.sample
        start_date + duration.days
      end
    end

    trait :titled do
      title { 'Fun Times' }
    end

    trait :unowned do
      user { nil }
    end

    trait :now do
      start_date { Date.today }
      end_date { Date.today }
    end
  end
end
