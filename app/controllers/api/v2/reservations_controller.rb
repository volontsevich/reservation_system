module Api
  module V2
    class ReservationsController < Api::V1::ReservationsController
      def create
        return render json: { error: "Restaurant not found" }, status: :not_found unless @restaurant

        service = ::V1::ReservationService.new(@restaurant, reservation_params)
        result = service.call

        render result
      end
    end
  end
end