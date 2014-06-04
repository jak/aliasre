Aliasre::Application.routes.draw do
  resources :hostnames, path: 'aliases', param: :name do
    member do
      get :updateip
      get :generate_new_token
    end
  end

  authenticated :user do
    root to: "hostnames#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "home#index"
  end

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end
