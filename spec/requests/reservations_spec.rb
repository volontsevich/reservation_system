require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  describe "POST /restaurants/:restaurant_id/reservations" do
    let(:restaurant) { FactoryBot.create(:restaurant) }
    let!(:table) { FactoryBot.create(:table, restaurant: restaurant) }
    let(:valid_attributes) {
      { party_size: Table::MIN_SEATS_AMOUNT, start_time: Time.now.to_i, duration: 3600 }
    }

    it "creates a new Reservation" do
      expect {
        post restaurant_reservations_path(restaurant), params: valid_attributes
      }.to change(Reservation, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "POST /restaurants/:restaurant_id/reservations" do
    let(:restaurant) { FactoryBot.create(:restaurant) }
    let(:occupied_table) {
      FactoryBot.create(:table, restaurant: restaurant, seats_amount: 4)
    }
    let!(:existing_reservation) {
      FactoryBot.create(:reservation, table: occupied_table, start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    }
    let(:conflicting_attributes) {
      { party_size: 4, start_time: 1.hour.from_now.to_i, duration: 3600 }
    }

    it "does not create a reservation when no tables are available" do
      expect {
        post restaurant_reservations_path(restaurant), params: conflicting_attributes
      }.not_to change(Reservation, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("No available tables")
    end
  end
end
