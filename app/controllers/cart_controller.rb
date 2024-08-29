class CartController < ApplicationController
  skip_before_action :verify_authenticity_token
<<<<<<< HEAD
  before_action :set_produto, only: [:update_quantity]
=======
  # before_action :set_produto, only: [:update_quantity]
>>>>>>> 88ac1b4 (teste)


  def add_to_cart
    produto_id = params[:id].to_i
    qtde = params[:qtde].to_i
  
    if qtde <= 0
      render json: { status: 'fail', message: 'Quantidade inválida' }, status: :bad_request
      return
    end
  
    produto = Produtos.find_by(id: produto_id)
    unless produto
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
      return
    end

    if qtde > produto.qtde
      render json: { status: 'fail', message: 'Quantidade solicitada excede o estoque disponível' }, status: :bad_request
      return
    end

    cart = session[:cart] || []
    produto_existente = cart.find { |item| item['id'] == produto_id }
  
    if produto_existente
      nova_qtde = produto_existente['qtde'] + qtde
      if nova_qtde > produto.qtde
        render json: { status: 'fail', message: 'Quantidade total no carrinho excede o estoque disponível' }, status: :bad_request
        return
      end
      produto_existente['qtde'] = nova_qtde
    else
      cart << { 'id' => produto.id, 'qtde' => qtde }
    end
  
    session[:cart] = cart
    Rails.logger.debug "Carrinho atualizado: #{session[:cart].inspect}"
    render json: { status: 'success', message: 'Produto adicionado ao carrinho', cart: cart }, status: :ok
  end
  
  def show
<<<<<<< HEAD
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
  
=======
    if request.format.html?
      # Renderiza a visualização HTML se o formato for HTML
      @cart_items = fetch_cart_items
      @total_price = @cart_items.sum { |item| item[:price].to_f * item[:quantity] }
      render :show
    else
      # Renderiza JSON para outras requisições
      cart = session[:cart] || []
      total_price = 0
  
      cart.each do |item|
        produto = Produtos.find_by(id: item['id'])
        if produto
          total_price += produto.preco.to_f * item['qtde']
        end
      end
  
      render json: { status: 'success', cart: cart, total_price: total_price }, status: :ok
    end
  end 
  
  def fetch_cart_items
    cart = session[:cart] || []
    cart.map do |item|
      produto = Produtos.find_by(id: item['id'])
      if produto
        {
          name: produto.nome,
          price: produto.preco,
          quantity: item['qtde']
        }
      end
    end.compact
  end  

>>>>>>> 88ac1b4 (teste)
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
<<<<<<< HEAD
    session[:cart] = []
    render json: { status: 'success', message: 'Carrinho esvaziado com sucesso' }, status: :ok
=======
    session[:cart] = [] # Limpa o carrinho
    if request.format.html?
      redirect_to '/cart', notice: 'Carrinho limpo com sucesso.' # Redireciona para a página do carrinho
    else
      render json: { status: 'success', message: 'Carrinho limpo com sucesso.' }, status: :ok
    end
>>>>>>> 88ac1b4 (teste)
  end

  private

  def set_produto
    @produto = Produtos.find_by(id: params[:id]) # Alterado para usar :id
    unless @produto
      render json: { status: 'fail', message: 'Produto não encontrado' }, status: :not_found
    end
  end
end
