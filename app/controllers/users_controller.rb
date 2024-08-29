class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  # Exibe todos os produtos disponíveis
  def index
    @products = Produtos.all
<<<<<<< HEAD
    render json: { status: 'success', products: @products }, status: :ok
=======
    @user = current_user
    respond_to do |format|
      format.html # Renderiza a view 'index.html.erb'
      format.json { render json: @products } # Retorna JSON apenas se solicitado
    end
>>>>>>> 88ac1b4 (teste)
  end

  # Exibe os detalhes de um produto específico
  def show
    @produto = Produtos.find(params[:id])
    render json: { status: 'success', produto: @produto }, status: :ok
    rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Produto não encontrado' }, status: :not_found
<<<<<<< HEAD
    end    
=======
    end
    
  
>>>>>>> 88ac1b4 (teste)
end