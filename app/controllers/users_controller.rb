class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  # Exibe todos os produtos disponíveis
  def index
    @products = Product.all
    @user = current_user
    respond_to do |format|
      format.html # Renderiza a view 'index.html.erb'
      format.json { render json: @products } # Retorna JSON apenas se solicitado
    end
  end

  # Exibe os detalhes de um produto específico
  def show
    @product = Product.find(params[:id])
    render json: { status: 'success', product: @product }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Produto não encontrado' }, status: :not_found
  end
    
  
end