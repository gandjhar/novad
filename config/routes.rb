Rails.application.routes.draw do

  get 'site/home'

  get 'site/about'

  resources :authors
  resources :novels
  resources :genres

  root "authors#index"

end
