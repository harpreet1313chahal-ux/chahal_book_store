Rails.application.routes.draw do
  root "products#index"

  resources :products
  resources :categories
  resources :orders
  resources :provinces, only: [ :index, :edit, :update ]

  resources :users, only: [ :new, :create ]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resource :cart, controller: "carts", only: [ :show ] do
  post "add/:id", to: "carts#add", as: :add
  patch "update/:id", to: "carts#update", as: :update
  delete "remove/:id", to: "carts#remove", as: :remove

  get "checkout", to: "carts#checkout"
  post "place_order", to: "carts#place_order"

  # Stripe
  post "create_checkout_session", to: "carts#create_checkout_session"
  get "success", to: "carts#success"
end
end
