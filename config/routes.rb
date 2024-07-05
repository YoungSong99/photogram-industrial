Rails.application.routes.draw do
  root "photos#index"

  devise_for :users

  resources :comments
  resources :follow_requests
  resources :likes
  resources :photos

  get ":username/liked" => "photos#liked", as: :liked_photo
  get ":username/feed" => "photos#feed", as: :feed_photo

  get ":username" => "users#show", as: :user
end
