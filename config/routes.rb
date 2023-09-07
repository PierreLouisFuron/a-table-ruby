Rails.application.routes.draw do
  resources :recipes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  get "menus", to: "menus#index"
  post '/update_menu_count', to: 'menus#update_menu_count' 

end
