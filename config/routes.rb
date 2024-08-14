Rails.application.routes.draw do
  # Rota para verificar a saúde do aplicativo
  get "up" => "rails/health#show", as: :rails_health_check

  # Rota de login
  post 'login', to: 'sessions#create'

  # Rotas para o administrador
  post 'admins/add_user', to: 'admins#add_user'
  delete 'admins/remove_user/:id', to: 'admins#remove_user', as: 'remove_user'
  get 'admins/list_users', to: 'admins#list_users'

  # Rotas para produtos
  post 'products/add', to: 'products#create', as: 'add_product'
  patch 'products/update/:id', to: 'products#update', as: 'update_product'
  delete 'products/remove/:id', to: 'products#destroy', as: 'remove_product'
  get 'products/list', to: 'products#index', as: 'list_products'
  get 'products/check_stock', to: 'products#check_stock', as: 'check_product_stock'

  # Rotas para usuários
  get 'users/products', to: 'users#index', as: 'user_products'
  get 'users/products/:id', to: 'users#show', as: 'user_product'
  post 'users/products/:id/add_to_cart', to: 'users#add_to_cart', as: 'user_cart'

  # Rotas para o carrinho
  get 'cart', to: 'cart#show', as: 'show_cart'
  delete 'cart/remove_product', to: 'cart#remove_product', as: 'cart_remove_product'
  patch 'cart/update_quantity', to: 'cart#update_quantity', as: 'cart_update_quantity'

  # Rotas para pagamentos
  get 'payment/new', to: 'payments#new', as: 'new_payment'
  post 'payment/create', to: 'payments#create', as: 'create_payment'
end
