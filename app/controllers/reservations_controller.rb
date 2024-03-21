class ReservationsController < ApplicationController
  before_action :set_restaurant
  before_action :parse_time, only: [:create]

  def create
    return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant
    table = find_available_table
    return render json: { error: "No available tables for the requested time and party size" }, status: :unprocessable_entity unless table

    reservation = table.reservations.new(reservation_params)

    if reservation.save
      render json: reservation, status: :created
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
  end

  def parse_time
    @start_time = Time.at(params[:start_time].to_i)
    @end_time = @start_time + params[:duration].to_i.seconds
  end

  def find_available_table
    # the first available table with the minimum amount of seats that fits party size
    @restaurant.tables
               .where('seats_amount >= ?', params[:party_size])
               .where.not(id: overlapping_reservations(@start_time, @end_time))
               .order(seats_amount: :asc)
               .first
  end

  def overlapping_reservations(start_time, end_time)
    Reservation.where('start_time < ? AND end_time > ?', end_time, start_time).select(:table_id)
  end

  def reservation_params
    params.permit(:party_size, :start_time).to_h.symbolize_keys.merge({
                                                                        start_time: @start_time,
                                                                        end_time: @end_time
                                                                      })
  end

end
