FactoryBot.define do
  factory :reservation do
    table { nil }
    party_size { 1 }
    start_time { "2024-03-21 00:08:31" }
    duration { 1 }
  end
end
