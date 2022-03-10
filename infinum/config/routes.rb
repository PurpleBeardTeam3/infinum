Rails.application.routes.draw do
  
  authenticate :user do
    resources :timelines,
    only: [:index, :show],
    param: :username
    resources :posts, only: [:create, :show]
   end
  devise_for :users
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
