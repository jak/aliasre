Aliasre::Application.routes.draw do
  resources :hostnames

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end