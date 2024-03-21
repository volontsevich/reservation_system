require 'rails_helper'

RSpec.describe 'Reservations API V2', type: :request do
  let(:restaurant) { FactoryBot.create(:restaurant) }
  let!(:tables) { FactoryBot.create_list(:table, 3, restaurant: restaurant) }
  let(:valid_attributes) do
    {
      party_size: Table::MIN_SEATS_AMOUNT,
      start_time: (Time.current + 2.hours).iso8601,
      duration: Reservation::STANDARD_BOOKING_TIME
    }
  end

  describe 'POST /api/v2/restaurants/:restaurant_id/reservations' do
    context 'when the request is valid' do
      before do
        post "/api/v2/restaurants/#{restaurant.id}/reservations", params: valid_attributes
      end

      it 'creates a new Reservation' do
        expect(response).to have_http_status(:created)
        expect(json['party_size']).to eq(2)
      end
    end

    context 'when the requested time is before opening hours' do
      before do
        early_time = (Time.current.change(hour: Restaurant::START_OF_WORKING_HOURS - 1)).iso8601
        post "/api/v2/restaurants/#{restaurant.id}/reservations", params: valid_attributes.merge(start_time: early_time)
      end

      it 'adjusts the reservation time to opening hours' do
        expect(response).to have_http_status(:created)
        expect(Time.parse(json['start_time']).hour).to eq(Restaurant::START_OF_WORKING_HOURS)
      end
    end

    context 'when the requested time is fully booked' do
      before do
        # Book all tables for the initially requested time slot
        tables.each do |table|
          FactoryBot.create(:reservation,
                            table: table,
                            start_time: valid_attributes[:start_time],
                            end_time: (Time.parse(valid_attributes[:start_time]) + valid_attributes[:duration].seconds).iso8601)
        end

        post "/api/v2/restaurants/#{restaurant.id}/reservations", params: valid_attributes
      end

      it 'finds the next available slot and creates a new Reservation' do
        expect(response).to have_http_status(:created)
        # Verify that the reservation's start time has been adjusted to a later time
        expect(Time.parse(json['start_time'])).to be > Time.parse(valid_attributes[:start_time])
      end
    end

    context 'when the request is invalid' do
      before do
        post "/api/v2/restaurants/#{restaurant.id}/reservations", params: { party_size: Table::MIN_SEATS_AMOUNT }
      end

      it 'returns status code 400' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
