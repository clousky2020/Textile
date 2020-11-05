Rails.application.routes.draw do

  root 'dashboard#index'
  post 'check_sale_order', to: 'dashboard#check_sale_order'


  resources :session, :only => [:new, :create, :destroy]
  resources :param, only: [:index, :update]
  resources :user do
    member do
      get :lock
      get :reset
    end
  end
  resources :employee
  resources :roles
  resources :purchase_supplier do
    collection do
      get :check_purchase_supplier
    end
  end
  resources :sale_customer do
    collection do
      get :check_sale_customer
    end
  end
  resources :purchase_order do
    member do
      get :pass_check
    end
  end
  resources :sale_order do
    member do
      get :pass_check
    end
  end
  resources :material do
    collection do
      get :check_material_name
      get :check_material_specification
    end
  end
  resources :product do
    collection do
      post :get_options
    end
  end
  resources :repo
  resources :proceed do
    member do
      get :pass_check
    end
  end
  resources :expense do
    member do
      get :pass_check
      get :pass_reimburse
    end
    collection do
      get :get_expense_type
    end
  end

  resources :password_resets, :only => [:edit, :update]


# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
