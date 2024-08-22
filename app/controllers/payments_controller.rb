class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Renderiza o formulário de pagamento
  def new
    render json: { status: 'success', message: 'Formulário de pagamento' }, status: :ok
  end


  # Adiciona saldo à carteira do usuário
  def add_balance
    saldo = params[:saldo].to_f
    user = User.find_by(ra: params[:ra])
    
    if saldo <= 0
      render json: { status: 'fail', message: 'Valor inválido' }, status: :bad_request
      return
    end
  
    if user
      user.update(saldo: user.saldo + saldo)
      render json: { status: 'success', message: "Saldo adicionado com sucesso! Saldo atual: #{user.saldo}" }, status: :ok
    else
      render json: { status: 'fail', message: 'Usuário não encontrado' }, status: :not_found
    end
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
        current_user.update(saldo: current_user.saldo - total_cart_value)
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
    user.saldo >= total_cart_value
  end

  # Calcula o valor total do carrinho
  def total_cart_value
    cart = session[:cart] || []
    total = 0
    cart.each do |item|
      produto = Produtos.find_by(id: item['id'])
      total += produto.preco.to_f * item['qtde'] if produto
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
      produto = Produtos.find_by(id: item["id"])

      if produto && produto.qtde >= item["qtde"]
        produto.update(qtde: produto.qtde - item["qtde"])
      else
        render json: { status: 'fail', message: "Quantidade insuficiente para o produto #{produto.nome}" }, status: :unprocessable_entity
        return
      end
    end

    session[:cart] = []
  end

  # Registra a compra na tabela "compra"
  def create_purchase
    cart = session[:cart] || []
    cart.each do |item|
      Compra.create(usuario_id: current_user.id, produto_id: item["id"], quantidade: item["qtde"], valor_total: item["qtde"] * Produtos.find_by(id: item["id"]).preco)
    end
  end
end
