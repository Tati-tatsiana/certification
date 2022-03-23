Rails.application.routes.draw do
  root to: 'pages#home'

  # Routes Dashboard => User jouney > Loueur
  get 'dashboard',      to: 'pages#dashboard'
  get 'my_cars',        to: 'dashboards#my_cars'
  get 'my_demands',     to: 'dashboards#my_demands'
  get 'entry_demands',  to: 'dashboards#entry_demands'
  post 'status/:value',        to: 'dashboards#status'
  # Routes Cars & bookings  => User jouney > Locataire
  resources :cars do
    resources :bookings
  end
end
