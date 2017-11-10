Rails.application.routes.draw do
  # router DSL docs: http://guides.rubyonrails.org/routing.html

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'contact#contact'
  get '/sign-up', to: 'users#new'

  resources :users
end
