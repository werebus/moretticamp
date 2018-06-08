FactoryBot.define do
  trait :sequenced do
    sequence :start_date do |n|
      # March, April, etc
      Date.new(Date.today.year, n + 3, 1)
    end

    end_date { start_date + 1.day }
  end

  trait :random_schedule do
    start_date { Date.new(Date.today.year, rand(6..8), rand(1..30)) }
    end_date do
      if start_date?
        start_date + ([0] * 7 + [1] * 4 + [2] * 3 + [4, 5, 6, 7, 8, 10]).sample.days
      else
        Date.new(Date.today.year, rand(6..8), rand(1..30))
      end
    end
  end
end
