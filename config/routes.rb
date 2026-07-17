Rails.application.routes.draw do
  root "products#index"

  resources :products
  resources :categories

  resource :cart, controller: "carts", only: [ :show ] do
  post "add/:id", to: "carts#add", as: :add
  patch "update/:id", to: "carts#update", as: :update
  delete "remove/:id", to: "carts#remove", as: :remove

  get "checkout", to: "carts#checkout"
  post "place_order", to: "carts#place_order"
end
end
