Rails.application.routes.draw do
  namespace :api do

    namespace :v1 do
      get 'restaurants', to: 'restaurants#index'
      get 'restaurants/:restaurant_id/tables/occupied', to: 'tables#occupied', as: :restaurant_occupied_tables

      post 'restaurants/:restaurant_id/reservations', to: 'reservations#create', as: :restaurant_reservations
    end

    namespace :v2 do
      get 'restaurants', to: '/api/v1/restaurants#index'
      get 'restaurants/:restaurant_id/tables/occupied', to: '/api/v1/tables#occupied', as: :restaurant_occupied_tables

      post 'restaurants/:restaurant_id/reservations', to: 'reservations#create', as: :restaurant_reservations
    end
  end
end
