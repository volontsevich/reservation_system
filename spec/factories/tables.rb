FactoryBot.define do
  factory :table do
    association :restaurant
    sequence(:number) { |n| n }
    seats_amount { Faker::Number.between(from: Table::MIN_SEATS_AMOUNT, to: Table::MAX_SEATS_AMOUNT) }
  end
end
