Rails.application.routes.draw do

  root "home#index"
  resources :recipes do
    resources :images, only: [:index]
    delete 'image/:id', to: 'recipes#destroy_image', as: 'destroy_image'
    post 'add_to_meals', to: 'recipes#add_recipe_to_meals'
  end
  # get "menus", to: "menus#index"
  # post 'menus', to: 'menus#create'

  resources :menus, only: [:index, :create, :destroy]
  post '/update_menu_count', to: 'menus#update_menu_count'
  # get '/add_recipe_to_menu', to: 'menus#add_recipe_to_menu'
  #
  post '/add_recipe_to_menu', to: 'menus#add_recipe_to_menu'
  post '/remove_recipe_from_menu', to: 'menus#remove_recipe_from_menu'
  post '/update_meal', to: 'menus#update_meal'

  post 'meals', to: 'meals#create'

  get 'search_recipes', to: 'recipes#search'

  get 'dev', to: 'dev#index'

end
