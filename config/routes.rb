Rails.application.routes.draw do
  post '/restaurants/:restaurant_id/reservations', to: 'reservations#create', as: :restaurant_reservations
  get '/restaurants/:restaurant_id/tables/occupied', to: 'tables#occupied', as: :restaurant_occupied_tables
end
