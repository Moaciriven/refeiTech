class UsersController < ApplicationController
  before_action :set_product, only: [:show, :add_to_cart]
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API


  # Exibe todos os produtos disponíveis
  def index
    @products = Produtos.all
    render json: { status: 'success', products: @products }, status: :ok
  end

  # Exibe os detalhes de um produto específico
  def show
    render json: { status: 'success', product: @product }, status: :ok
  end

  # Adiciona o produto ao carrinho
  def add_to_cart
    cart = session[:cart] || [] # Recupera o carrinho da sessão ou inicializa um novo

    if @product
      cart << @product.id # Adiciona o ID do produto ao carrinho
      session[:cart] = cart # Atualiza o carrinho na sessão
      render json: { status: 'success', message: 'Produto adicionado ao carrinho', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end

  private

  # Define o produto com base no id fornecido
  def set_product
    @product = Produtos.find_by(id: params[:id])
    unless @product
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end
end
