Rails.application.routes.draw do
  # router DSL docs: http://guides.rubyonrails.org/routing.html

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'contact#contact'

  get '/sign-up', to: 'users#new'
  post '/sign-up', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      patch :edit, action: 'update'
      get 'change-password', action: 'edit_password'
      patch 'change-password', action: 'update_password'

      get :following
      get :followers
    end
  end

  resources :microposts, only: [:create, :destroy]
  post '/', to: 'microposts#create'

  resources :relationships, only: [:create, :destroy]

  resources :locations do
    resources :trails
  end

  resources :rides

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :locations, :trails, :rides
    end
  end

end
