class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Renderiza o formulário de pagamento
  def new
    render json: { status: 'success', message: 'Formulário de pagamento' }, status: :ok
  end

  # Cria o pagamento com base no método e nas informações fornecidas
  def create
    payment_method = params[:payment_method]

    if payment_method == 'credit_card'
      if valid_credit_card?(params) && payment_successful?(0.20)
        process_payment
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Cartão de Crédito!' }, status: :ok
      else
        render json: { status: 'fail', message: 'Falha na validação do pagamento com Cartão de Crédito' }, status: :unprocessable_entity
      end
    elsif payment_method == 'pix'
      if valid_pix?(params) && payment_successful?(0.80)
        process_payment
        render json: { status: 'success', message: 'Pagamento realizado com sucesso com Pix' }, status: :ok
      else
        render json: { status: 'fail', message: 'Falha na validação do pagamento com Pix' }, status: :unprocessable_entity
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
end
