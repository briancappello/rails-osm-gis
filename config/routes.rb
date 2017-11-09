Rails.application.routes.draw do
  # router DSL docs: http://guides.rubyonrails.org/routing.html
  root 'application#hello'

  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
end
