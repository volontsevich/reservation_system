module Api
  module V1
    class ReservationsController < ApiController
      before_action :set_restaurant

      def create
        return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant

        service = ::V1::ReservationService.new(@restaurant, reservation_params)
        result = service.call

        render result
      end

      private

      def set_restaurant
        @restaurant = Restaurant.find_by(id: params[:restaurant_id])
      end

      def reservation_params
        params.permit(:party_size, :start_time, :duration).to_h.symbolize_keys
      end
    end
  end
end