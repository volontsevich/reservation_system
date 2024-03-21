Rails.application.routes.draw do
  post '/restaurants/:restaurant_id/reservations', to: 'reservations#create'
  get '/restaurants/:restaurant_id/tables/occupied', to: 'tables#occupied'
end
