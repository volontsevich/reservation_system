require 'rails_helper'

RSpec.describe Table, type: :model do
  let(:restaurant) { FactoryBot.create(:restaurant) }
  let(:valid_attributes) { { restaurant_id: restaurant.id, number: 1, seats_amount: Table::MIN_SEATS_AMOUNT } }

  context 'validations' do
    it 'is valid with valid attributes' do
      table = Table.new(valid_attributes)
      expect(table).to be_valid
    end

    it 'is not valid without a number' do
      table = Table.new(valid_attributes.except(:number))
      expect(table).not_to be_valid
    end

    it 'is not valid without a seats amount' do
      table = Table.new(valid_attributes.except(:seats_amount))
      expect(table).not_to be_valid
    end

    it 'is not valid with a non-unique number within the same restaurant' do
      Table.create!(valid_attributes.merge(restaurant: restaurant))
      duplicate_table = Table.new(valid_attributes.merge(restaurant: restaurant))
      expect(duplicate_table).not_to be_valid
    end

    it 'allows same table number in different restaurants' do
      restaurant1 = restaurant
      restaurant2 = FactoryBot.create(:restaurant)
      Table.create!(valid_attributes.merge(restaurant: restaurant1))
      table_in_another_restaurant = Table.new(valid_attributes.merge(restaurant: restaurant2))
      expect(table_in_another_restaurant).to be_valid
    end
  end
end
