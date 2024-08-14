class CartController < ApplicationController
  before_action :set_cart, only: [:show, :add_product, :remove_product, :update_quantity]
  skip_before_action :verify_authenticity_token # Ignora verificação CSRF para API

  def show
    render json: { status: 'success', cart: @cart }, status: :ok
  end

  def remove_product
    produto = Produto.find_by(id: params[:product_id])
    if produto && @cart.delete_if { |item| item[:produto]["id"] == produto.id }
      session[:cart] = @cart
      render json: { status: 'success', message: 'Produto removido do carrinho', cart: @cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
    end
  end

  def update_quantity
    produto = Produto.find_by(id: params[:product_id])
    if produto
      item = @cart.find { |i| i[:produto]["id"] == produto.id }
      if item
        item[:quantity] = params[:quantity].to_i
        session[:cart] = @cart
        render json: { status: 'success', message: 'Quantidade atualizada', cart: @cart }, status: :ok
      else
        render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
      end
    else
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end

  private

  def set_cart
    @cart = session[:cart] || []
  end
end
