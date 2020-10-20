Rails.application.routes.draw do
  root 'dashboard#index'
  resources :session, :only => [:new, :create, :destroy]
  resources :user
  resources :password_resets, :only => [:edit, :update] do
    member do
      get :reset
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
