class TablesController < ApplicationController
  before_action :set_restaurant

  def occupied
    return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant

    service = OccupiedTablesService.new(@restaurant, params[:time])
    occupied_tables_with_reservations = service.call

    render json: occupied_tables_with_reservations
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:restaurant_id])
  end
end
