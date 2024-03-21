# Create few restaurants with tables

2.times do |i|
  restaurant = Restaurant.create(name: 'The Ruby Grill')


  # Create tables for the restaurant
  5.times do |j|
    Table.create(restaurant: restaurant, number: j + 1, seats: 4)
  end
end