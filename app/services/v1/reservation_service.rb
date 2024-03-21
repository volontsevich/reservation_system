module V1
  class ReservationService

    def initialize(restaurant, reservation_params)
      @restaurant = restaurant
      @reservation_params = reservation_params
      begin
        @start_time = Time.parse(reservation_params[:start_time])
        @end_time = @start_time + reservation_params[:duration].to_i.seconds
      rescue
        @error = { json: { error: "Invalid time format" }, status: :bad_request }
      end
    end

    def call
      return @error if @error

      table = find_available_table
      return { error: "No available tables for the requested time and party size", status: :unprocessable_entity } unless table

      reservation = table.reservations.create(@reservation_params.merge(start_time: @start_time, end_time: @end_time).except(:duration))

      if reservation.persisted?
        { json: reservation, status: :created }
      else
        { json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity }
      end
    end

    private

    def find_available_table
      @restaurant.tables
                 .where('seats_amount >= ?', @reservation_params[:party_size])
                 .where.not(id: overlapping_reservations)
                 .order(seats_amount: :asc)
                 .first
    end

    def overlapping_reservations
      Reservation.where('start_time < ? AND end_time > ?', @end_time, @start_time).select(:table_id)
    end
  end
end
