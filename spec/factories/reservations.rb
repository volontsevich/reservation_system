FactoryBot.define do
  factory :reservation do
    association :table
    party_size { Faker::Number.between(from: Table::MIN_SEATS_AMOUNT, to: Table::MAX_SEATS_AMOUNT) }
    start_time { 1.hour.from_now }
    end_time { 2.hours.from_now }
  end
end
