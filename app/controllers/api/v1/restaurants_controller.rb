module Api
  module V1
    class RestaurantsController < ApiController

      def index
        render json: Restaurant.all.select(:id, :name)
      end
    end
  end
end
