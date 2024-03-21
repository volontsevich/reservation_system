class RestaurantsController < ApplicationController

  def index
    render json: Restaurant.all.select(:id, :name)
  end
end
