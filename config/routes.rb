Rails.application.routes.draw do
  resources :follow_requests
  resources :comments
  devise_for :users
  resources :photos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "photos#index"
end
