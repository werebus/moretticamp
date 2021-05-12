# frozen_string_literal: true

FactoryBot.define do
  trait :with_year do
    transient do
      year { Time.zone.today.year }
    end
  end

  trait :sequenced do
    sequence :start_date do |n|
      # March, April, etc
      Date.new(year, n + 3, 1)
    end

    end_date { start_date + 1.day }
  end
end
