# Create few restaurants with tables
RESTAURANT_AMOUNT = 2
TABLES_PER_RESTAURANT = 5
MIN_SEATS_AMOUNT = 2
MAX_SEATS_AMOUNT = 5

RESTAURANT_AMOUNT.times do |_|
  restaurant = Restaurant.create(name: Faker::Restaurant.name)

  # Create tables for the restaurant
  TABLES_PER_RESTAURANT.times do |j|
    Table.create(restaurant: restaurant, number: j + 1, seats_amount: Faker::Number.between(from: MIN_SEATS_AMOUNT, to: MAX_SEATS_AMOUNT))
  end
end