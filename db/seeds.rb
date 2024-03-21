# Create few restaurants with tables
RESTAURANT_AMOUNT = 2

RESTAURANT_AMOUNT.times do |_|
  restaurant = Restaurant.create(name: Faker::Restaurant.name)

  # Create tables for the restaurant
  Restaurant::TABLES_PER_RESTAURANT.times do |j|
    Table.create(restaurant: restaurant, number: j + 1, seats_amount: Faker::Number.between(from: Table::MIN_SEATS_AMOUNT, to: Table::MAX_SEATS_AMOUNT))
  end
end