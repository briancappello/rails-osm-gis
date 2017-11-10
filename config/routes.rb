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
    patch 'edit', on: :member, action: 'update'
    get 'change-password', on: :member, action: 'edit_password'
    patch 'change-password', on: :member, action: 'update_password'
  end
end
