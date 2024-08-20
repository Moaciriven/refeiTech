class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  # Exibe todos os produtos disponíveis
  def index
    @products = Produtos.all
    render json: { status: 'success', products: @products }, status: :ok
  end

  # Exibe os detalhes de um produto específico
  def show
    @produto = Produtos.find(params[:id])
    render json: { status: 'success', produto: @produto }, status: :ok
    rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Produto não encontrado' }, status: :not_found
    end    
end