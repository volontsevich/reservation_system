class TablesController < ApplicationController
  before_action :set_restaurant
  before_action :parse_time, only: [:occupied]

  def occupied
    return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant
    occupied_tables = find_occupied_tables(@time)
    render json: occupied_tables.select(:id, :number, :seats_amount)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
  end

  def parse_time
    @time = Time.at(params[:time].to_i)
  end

  def find_occupied_tables(time)
    @restaurant.tables.joins(:reservations)
               .where('reservations.start_time <= :time AND reservations.end_time > :time', time: time)
               .distinct
  end
end
