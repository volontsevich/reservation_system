Rails.application.routes.draw do
  get '/restaurants', to: 'restaurants#index'
  post '/restaurants/:restaurant_id/reservations', to: 'reservations#create', as: :restaurant_reservations
  get '/restaurants/:restaurant_id/tables/occupied', to: 'tables#occupied', as: :restaurant_occupied_tables
end
