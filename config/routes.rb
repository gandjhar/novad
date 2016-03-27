Rails.application.routes.draw do

  resources :authors
  resources :novels
  resources :genres

  get "about" => "site#about"

  root "site#home"

end
