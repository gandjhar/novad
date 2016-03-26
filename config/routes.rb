Rails.application.routes.draw do

  get 'novels/index'

  get 'novels/show'

  resources :authors

end
