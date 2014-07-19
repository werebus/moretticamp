# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    user
    random_schedule

    trait :titled do
      title "Fun Times"
    end

    trait :unowned do
      user nil
    end
  end
end
