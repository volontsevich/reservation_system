module Api
  module V1
    class TablesController < ApiController
      before_action :set_restaurant

      def occupied
        return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant

        service = ::V1::OccupiedTablesService.new(@restaurant, params[:time])
        occupied_tables_with_reservations = service.call

        render json: occupied_tables_with_reservations
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find_by(id: params[:restaurant_id])
      end
    end
  end
end
