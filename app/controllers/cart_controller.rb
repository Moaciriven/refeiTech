class CartController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_produto, only: [:update_quantity]


  def add_to_cart
    produto_id = params[:id].to_i
    qtde = params[:qtde].to_i
  
    if qtde <= 0
      render json: { status: 'fail', message: 'Quantidade inválida' }, status: :bad_request
      return
    end
  
    cart = session[:cart] || []
    produto_existente = cart.find { |item| item['id'] == produto_id }
  
    if produto_existente
      produto_existente['qtde'] += qtde
    else
      produto = Produtos.find_by(id: produto_id)
      if produto
        cart << { 'id' => produto.id, 'qtde' => qtde }
      else
        render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
        return
      end
    end
  
    session[:cart] = cart
    Rails.logger.debug "Carrinho atualizado: #{session[:cart].inspect}"
    render json: { status: 'success', message: 'Produto adicionado ao carrinho', cart: cart }, status: :ok
  end
  
  def show
    cart = session[:cart] || []
    Rails.logger.debug "Carrinho no show: #{cart.inspect}"
    total_price = 0
  
    cart.each do |item|
      produto = Produtos.find_by(id: item['id'])
      if produto
        total_price += produto.preco.to_f * item['qtde']
      end
    end
  
    render json: { status: 'success', cart: cart, total_price: total_price }, status: :ok
  end
  
  def update_quantity
    Rails.logger.info "Parameters: #{params.inspect}" # Adiciona log para depuração
    qtde = params[:qtde].to_i
    cart = session[:cart] || []
    produto_no_carrinho = cart.find { |item| item['id'] == @produto.id }
  
    if produto_no_carrinho
      produto_no_carrinho['qtde'] = qtde
      session[:cart] = cart
      render json: { status: 'success', message: 'Quantidade atualizada no carrinho', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
    end
  end
  
  def remove_product
    produto_id = params[:product_id].to_i
    cart = session[:cart] || []
  
    produto_no_carrinho = cart.find { |item| item['id'] == produto_id }
  
    if produto_no_carrinho
      cart.delete(produto_no_carrinho)
      session[:cart] = cart
      render json: { status: 'success', message: 'Produto removido do carrinho', cart: cart }, status: :ok
    else
      render json: { status: 'fail', message: 'Produto não encontrado no carrinho' }, status: :not_found
    end
  end
  

  def clear_cart
    session[:cart] = []
    render json: { status: 'success', message: 'Carrinho esvaziado com sucesso' }, status: :ok
  end

  private

  def set_produto
    @produto = Produtos.find_by(id: params[:id]) # Alterado para usar :id
    unless @produto
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end
end
