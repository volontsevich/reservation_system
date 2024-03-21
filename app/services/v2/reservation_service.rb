module V2
  class ReservationService

    def initialize(restaurant, reservation_params)
      @restaurant = restaurant
      @reservation_params = reservation_params
      begin
        parsed_start_time = Time.parse(reservation_params[:start_time])
        @start_time = adjust_start_time_to_working_hours(parsed_start_time)
        @duration = reservation_params[:duration].to_i.seconds
        @end_time = @start_time + @duration
      rescue
        @error = { json: { error: "Invalid time format" }, status: :bad_request }
      end
    end

    def call
      return @error if @error

      table, new_start_time = find_next_available_table_and_time
      return { json: { error: "No available tables for the requested time and party size" }, status: :unprocessable_entity } unless table

      reservation = table.reservations.create(@reservation_params.merge(start_time: new_start_time, end_time: new_start_time + @duration).except(:duration))

      if reservation.persisted?
        { json: reservation, status: :created }
      else
        { json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity }
      end
    end

    private

    def adjust_start_time_to_working_hours(parsed_start_time)
      if parsed_start_time.hour < Restaurant::START_OF_WORKING_HOURS
        parsed_start_time.change(hour: Restaurant::START_OF_WORKING_HOURS)
      else
        parsed_start_time
      end
    end

    def find_next_available_table_and_time
      new_start_time = @start_time
      new_end_time = new_start_time + @duration
      loop do
        break if new_end_time.hour > Restaurant::END_OF_WORKING_HOURS
        available_table = @restaurant.tables
                                     .where('seats_amount >= ?', @reservation_params[:party_size])
                                     .where.not(id: overlapping_reservations(new_start_time, new_end_time))
                                     .order(seats_amount: :asc)
                                     .first

        return [available_table, new_start_time] if available_table

        new_start_time += Reservation::BOOKING_FREQUENCY
        new_end_time = new_start_time + @duration
      end
      [nil, nil] # No available table found within the working hours
    end

    def overlapping_reservations(start_time, end_time)
      Reservation.where('start_time < ? AND end_time > ?', end_time, start_time).select(:table_id)
    end
  end
end
