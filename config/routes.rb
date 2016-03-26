Rails.application.routes.draw do

  resources :authors
  resources :novels
  resources :genres

  root "authors#index"

end
