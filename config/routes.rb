Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #Root
  root to: 'dashboard#index'
  get '/categories/:category_id/page/:page', to: 'dashboard#index'
end
