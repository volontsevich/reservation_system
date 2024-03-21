require 'rails_helper'

RSpec.describe "Tables", type: :request do
  describe "GET /restaurants/:restaurant_id/tables/occupied" do
    let!(:restaurant) { FactoryBot.create(:restaurant) }
    let!(:table1) { FactoryBot.create(:table, restaurant: restaurant, seats_amount: Table::MIN_SEATS_AMOUNT) }
    let!(:table2) { FactoryBot.create(:table, restaurant: restaurant, seats_amount: Table::MIN_SEATS_AMOUNT) }
    let!(:reservation) {
      FactoryBot.create(:reservation, table: table1, start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    }
    let(:requested_time) { 1.hour.from_now + 1.second}

    it "returns occupied tables for the specified time" do
      get restaurant_occupied_tables_path(restaurant), params: { time: requested_time }
      expect(response).to have_http_status(:ok)
      occupied_tables = JSON.parse(response.body)
      expect(occupied_tables.count).to eq(1)
      expect(occupied_tables.first['table_id']).to eq(table1.id)
      expect(occupied_tables.first['reservations'].first['reservation_id']).to eq(reservation.id)
      expect(occupied_tables.first['reservations'].first['party_size']).to eq(reservation.party_size)
    end

    it "returns no occupied tables outside reservation times" do
      get restaurant_occupied_tables_path(restaurant), params: { time: 3.hours.from_now }
      expect(response).to have_http_status(:ok)
      occupied_tables = JSON.parse(response.body)
      expect(occupied_tables).to be_empty
    end
  end
end