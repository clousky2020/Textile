Rails.application.routes.draw do

  root 'dashboard#index'
  post 'check_orders_money', to: 'dashboard#check_orders_money'
  post 'check_trade_top', to: 'dashboard#check_trade_top'
  post 'check_expense_ratio', to: 'dashboard#check_expense_ratio'
  post 'check_purchase_supplier', to: 'dashboard#check_purchase_supplier'
  post 'check_sale_customer', to: 'dashboard#check_sale_customer'
  post 'intro_clear', to: 'dashboard#intro_clear'

  resources :sessions, :only => [:new, :create, :destroy]
  resources :settings, only: [:index, :update]
  resources :introjs, only: [:create, :destroy] do
    collection do
      post :find_attribute
    end
  end
  resources :comments, only: [:index, :create, :destroy] do
    get :take_top, on: :member
  end
  resources :users do
    member do
      get :lock
      get :reset
    end
  end
  resources :employee
  resources :roles
  resources :purchase_suppliers do
    collection do
      get :check_purchase_supplier
    end
    member do
      get :export
    end
  end
  resources :sale_customers do
    collection do
      get :check_sale_customer
    end
    member do
      get :export
    end
  end
  resources :purchase_orders do
    member do
      get :pass_check
    end
  end
  resources :sale_orders do
    member do
      get :pass_check
    end
  end
  resources :materials do
    collection do
      get :check_material_name
      get :check_material_specification
    end
  end
  resources :products do
    collection do
      post :get_options
    end
  end
  resources :repos
  resources :proceeds do
    member do
      get :pass_check
    end
  end
  resources :expenses do
    member do
      get :pass_check
      get :pass_reimburse
    end
    collection do
      get :get_expense_type
    end
  end
  resources :change_machines do
    member do
      get :pass_settle
    end
  end
  resources :password_resets, :only => [:edit, :update]


# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
