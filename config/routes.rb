Aliasre::Application.routes.draw do
  resources :hostnames, path: 'aliases'

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end