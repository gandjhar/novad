Rails.application.routes.draw do

  resources :authors
  resources :novels

  root "authors#index"

end
