module V1
  class OccupiedTablesService
    def initialize(restaurant, time_params)
      @restaurant = restaurant
      @time = Time.parse(time_params)
    rescue ArgumentError
      @error = { json: { error: "Invalid time format" }, status: :bad_request }
    end

    def call
      return @error if @error

      occupied_tables_with_reservations.map do |table|
        {
          table_id: table.id,
          table_number: table.number,
          seats_amount: table.seats_amount,
          reservations: reservations_for_table(table)
        }
      end
    end

    private

    def occupied_tables_with_reservations
      @restaurant.tables.joins(:reservations)
                 .where('reservations.start_time <= :time AND reservations.end_time > :time', time: @time)
                 .distinct
    end

    def reservations_for_table(table)
      table.reservations.select(:id, :start_time, :end_time, :party_size)
           .where('start_time <= ? AND end_time > ?', @time, @time)
           .map do |reservation|
        {
          reservation_id: reservation.id,
          start_time: reservation.start_time,
          end_time: reservation.end_time,
          party_size: reservation.party_size
        }
      end
    end
  end
end
