require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  let(:valid_attributes) {
    {
      party_size: Table::MIN_SEATS_AMOUNT,
      start_time: Time.now,
      duration: Reservation::STANDARD_BOOKING_TIME }
  }

  describe "API V1 POST /api/v1/restaurants/:restaurant_id/reservations" do
    let(:restaurant) { FactoryBot.create(:restaurant) }
    let!(:table) { FactoryBot.create(:table, restaurant: restaurant) }

    it "creates a new Reservation" do
      expect {
        post api_v1_restaurant_reservations_path(restaurant), params: valid_attributes
      }.to change(Reservation, :count).by(1)

      expect(response).to have_http_status(:created)
    end
  end

  describe "API V1 POST /api/v1/restaurants/:restaurant_id/reservations" do
    let(:restaurant) { FactoryBot.create(:restaurant) }
    let(:occupied_table) { FactoryBot.create(:table, restaurant: restaurant) }
    let!(:existing_reservation) {
      FactoryBot.create(:reservation, table: occupied_table, start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    }
    let(:conflicting_attributes) {
      valid_attributes.merge(start_time: existing_reservation.start_time)
    }
    let(:no_time_in_attributes) {
      valid_attributes.except(:start_time)
    }

    it "does not create a reservation when no tables are available" do
      expect {
        post api_v1_restaurant_reservations_path(restaurant), params: conflicting_attributes
      }.not_to change(Reservation, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not create a reservation when no time is specified" do
      expect {
        post api_v1_restaurant_reservations_path(restaurant), params: no_time_in_attributes
      }.not_to change(Reservation, :count)

      expect(response).to have_http_status(:bad_request)
    end
  end
end
