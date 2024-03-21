require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:valid_attributes) { { name: Faker::Restaurant.name } }
  context 'validations' do
    it "is not valid without a name" do
      restaurant = Restaurant.new(name: nil)
      expect(restaurant).not_to be_valid
    end

    it 'is valid with valid attributes' do
      restaurant = Restaurant.new(valid_attributes)
      expect(restaurant).to be_valid
    end
  end
end
