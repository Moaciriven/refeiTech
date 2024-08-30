class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Renderiza o formulário de pagamento
  def new
    render json: { status: 'success', message: 'Formulário de pagamento' }, status: :ok
  end
  
  # Mostra o Saldo
  def show_balance

    if @current_user
      render json: { status: 'success', balance: user.balance }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
  end

  # Adiciona saldo à carteira do usuário
  def add_balance
    amount = params[:amount].to_f
  
    if amount <= 0
      render json: { status: 'fail', message: 'Valor inválido' }, status: :bad_request
      return
    end
  
    current_user.update(balance: current_user.balance + amount)
    render json: { status: 'success', message: "Saldo adicionado com sucesso! Saldo atual: #{current_user.balance}" }, status: :ok
  end

  # Cria o pagamento com base no método e nas informações fornecidas
  def create
    payment_method = params[:payment_method]

    if payment_method == 'credit_card'
      if valid_credit_card?(params) && payment_successful?(0.20)
        process_payment
        create_purchase
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Cartão de Crédito!' }, status: :ok
      else
        render json: { status: 'fail', message: 'Falha na validação do pagamento com Cartão de Crédito' }, status: :unprocessable_entity
      end
    elsif payment_method == 'pix'
      if valid_pix?(params) && payment_successful?(0.80)
        process_payment
        create_purchase
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Pix' }, status: :ok
      else
        render json: { status: 'fail', message: 'Falha na validação do pagamento com Pix' }, status: :unprocessable_entity
      end
    elsif payment_method == 'carteira'
      if valid_wallet_payment?(current_user)
        process_payment
        current_user.update(balance: current_user.balance - total_cart_value)
        create_purchase
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Carteira' }, status: :ok
      else
        render json: { status: 'fail', message: 'Saldo insuficiente na carteira' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'fail', message: 'Método de pagamento inválido' }, status: :unprocessable_entity
    end
  end

  private

  # Valida os dados do cartão de crédito
  def valid_credit_card?(params)
    params[:card_number].present? && params[:expiration_date].present? && params[:cvv].present?
  end

  # Valida a chave Pix
  def valid_pix?(params)
    params[:pix_key].present?
  end

  # Verifica se o usuário tem saldo suficiente na carteira
  def valid_wallet_payment?(user)
    user.balance >= total_cart_value
  end

  # Calcula o valor total do carrinho
  def total_cart_value
    cart = session[:cart] || []
    total = 0
    cart.each do |item|
      product = Product.find_by(id: item['id'])
      total += product.price.to_f * item['quantity'] if product
    end
    total
  end

  # Simula a probabilidade de sucesso do pagamento
  def payment_successful?(probability)
    rand < probability
  end

  # Processa o pagamento e atualiza o estoque
  def process_payment
    cart = session[:cart] || []
    cart.each do |item|
      product = Product.find_by(id: item["id"])

      if product && product.quantity >= item["qtde"]
        product.update(quantity: product.quantity - item["quantity"])
      else
        render json: { status: 'fail', message: "Quantidade insuficiente para o produto #{product.name}" }, status: :unprocessable_entity
        return
      end
    end

    session[:cart] = []
  end

  # Registra a compra na tabela "compra"
  def create_purchase
    cart = session[:cart] || []
    cart.each do |item|
      Payment.create(user_id: current_user.id, product_id: item["id"], quantity: item["qtde"], total_value: item["quantity"] * Product.find_by(id: item["id"]).price)
    end
  end
end
