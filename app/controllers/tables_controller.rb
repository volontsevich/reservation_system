class TablesController < ApplicationController
  before_action :set_restaurant
  before_action :parse_time, only: [:occupied]

  def occupied
    return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant
    occupied_tables = find_occupied_tables(@time)
    occupied_tables_with_reservations = occupied_tables.map do |table|
      {
        table_id: table.id,
        table_number: table.number,
        seats_amount: table.seats_amount,
        reservations: table.reservations.select(:id, :start_time, :end_time, :party_size)
                           .where('start_time <= ? AND end_time > ?', @time, @time)
                           .map do |reservation|
          {
            reservation_id: reservation.id,
            start_time: reservation.start_time,
            end_time: reservation.end_time,
            party_size: reservation.party_size
          }
        end
      }
    end

    render json: occupied_tables_with_reservations
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
  end

  def parse_time
    @time = Time.parse(params[:time])
  rescue ArgumentError
    render json: { error: "Invalid time format" }, status: :bad_request
  end

  def find_occupied_tables(time)
    @restaurant.tables.joins(:reservations)
               .where('reservations.start_time <= :time AND reservations.end_time > :time', time: time)
               .distinct
  end
end
