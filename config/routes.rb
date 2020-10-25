Rails.application.routes.draw do
  root 'dashboard#index'
  resources :session, :only => [:new, :create, :destroy]
  resources :user do
    member do
      get :lock
    end
  end
  resources :employee
  resources :purchase_supplier
  resources :sale_customer
  resources :purchase_order
  resources :sale_order
  resources :material
  resources :product
  resources :repo

  resources :password_resets, :only => [:edit, :update] do
    member do
      get :reset
    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
