Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'pages#home'
  devise_for :users
  resources :users

  resources :schools, only: [:index, :show] do
    collection do
      get "map"
      get "list"
    end
  end
end
