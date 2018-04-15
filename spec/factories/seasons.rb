FactoryBot.define do
  factory :season do
    start_date Date.new(Date.today.year, 2, 15)
    end_date Date.new(Date.today.year, 11, 20)
  end
end
