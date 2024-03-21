require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:restaurant) { FactoryBot.create(:restaurant) }
  let(:table) { FactoryBot.create(:table, restaurant: restaurant) }
  let(:valid_attributes) {
    {
      table: table,
      party_size: Table::MIN_SEATS_AMOUNT,
      start_time: Time.current + 1.hour,
      end_time: Time.current + 3.hours
    }
  }

  context 'validations' do
    it 'is valid with valid attributes' do
      reservation = Reservation.new(valid_attributes)
      expect(reservation).to be_valid
    end

    it 'is not valid without a table' do
      reservation = Reservation.new(valid_attributes.except(:table))
      expect(reservation).not_to be_valid
    end

    it 'is not valid without a party size' do
      reservation = Reservation.new(valid_attributes.except(:party_size))
      expect(reservation).not_to be_valid
    end

    it 'is not valid without a start time' do
      reservation = Reservation.new(valid_attributes.except(:start_time))
      expect(reservation).not_to be_valid
    end

    it 'is not valid without an end time' do
      reservation = Reservation.new(valid_attributes.except(:end_time))
      expect(reservation).not_to be_valid
    end

    it 'is not valid if the end time is before the start time' do
      reservation = Reservation.new(valid_attributes.merge(end_time: Time.current))
      expect(reservation).not_to be_valid
    end
  end
end
