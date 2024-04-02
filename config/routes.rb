Rails.application.routes.draw do

  root "home#index"
  resources :recipes do
    resources :images, only: [:index]
    delete 'image/:id', to: 'recipes#destroy_image', as: 'destroy_image'
  end
  get "menus", to: "menus#index"
  post '/update_menu_count', to: 'menus#update_menu_count' 

end
