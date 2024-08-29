Rails.application.routes.draw do
  # Rota para verificar a saúde do aplicativo
  get "up" => "rails/health#show", as: :rails_health_check

  # Rota de login
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  # Rotas para o administrador
  post 'admins/add_user', to: 'admins#add_user'
  delete 'admins/remove_user/:id', to: 'admins#remove_user', as: 'remove_user'
  get 'admins/list_users', to: 'admins#list_users'

  # Rotas para produtos
  get 'products', to: 'products#index', as: 'products'
  post 'products/add', to: 'products#create', as: 'add_product'
  patch 'products/update/:id', to: 'products#update', as: 'update_product'
  delete 'products/remove/:id', to: 'products#destroy', as: 'remove_product'
  get 'products/list', to: 'products#index', as: 'list_products'
  get 'products/check_stock/:id', to: 'products#check_stock', as: 'check_product_stock'
  

  # Rotas para usuários
  get 'users/products', to: 'users#index', as: 'user_products'
  get 'users/products/:id', to: 'users#show', as: 'user_product'

  # Rotas para o carrinho
  post 'cart/add/:id', to: 'cart#add_to_cart', as: 'add_to_cart'
  get 'cart', to: 'cart#show', as: 'show_cart'
  patch 'cart/update_quantity/:id', to: 'cart#update_quantity', as: 'update_cart_quantity'
  delete 'cart/remove_product/:product_id', to: 'cart#remove_product', as: 'cart_remove_product'
  delete 'cart/clear', to: 'cart#clear_cart', as: 'clear_cart'

  # Rotas para pagamentos
  get 'payment/new', to: 'payments#new', as: 'new_payment'
  post 'payment/create', to: 'payments#create', as: 'create_payment'
  post 'payment/add_balance', to: 'payments#add_balance', as: 'add_balance' 
  get 'payment/show_balance/:user_id', to: 'payments#show_balance', as: 'show_balance'

  # Rotas para Perfil
  get '/profile/:id', to: 'profile#show', as: 'profile'

  get '/manifest.json', to: ->(_) { [200, { 'Content-Type' => 'application/json' }, [File.read(Rails.root.join('public', 'manifest.json'))]] }

end
