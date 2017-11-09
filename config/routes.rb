Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  # router DSL docs: http://guides.rubyonrails.org/routing.html

  root 'application#hello'
end
